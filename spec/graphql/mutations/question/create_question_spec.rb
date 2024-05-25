require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'CreateQuestion mutation', type: :request do
  let(:survey) { create(:survey) }
  let(:admin_user) { create(:user, is_admin: true) }

  it 'creates a new question' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createQuestion(input: {
            content: "What is the capital of France?",
            surveyId:  #{survey.id},
            questionType: "multiple_choice"
          }) {
            question {
              id
              content
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createQuestion']['question']['content']).to eq('What is the capital of France?')
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createQuestion(input: {
            content: "What is the capital of Brazil?",
            surveyId: #{survey.id},
            questionType: "multiple_choice"
          }) {
            question {
              id
              content
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createQuestion']['errors']).to eq(['You must be an administrator to create a new question'])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createQuestion(input: {
            content: "What is the capital of Germany?",
            surveyId: #{survey.id},
            questionType: "multiple_choice"
          }) {
            question {
              id
              content
            }
            errors
          }
        }
      GRAPHQL
    }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createQuestion']['errors']).to eq(['Authentication required'])
  end
end
