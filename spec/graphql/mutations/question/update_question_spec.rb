require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'UpdateQuestion mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }
  let(:survey) { create(:survey) }
  let(:question_to_update) { create(:question) }

  it 'updates a question when authorized' do
    admin_user = create(:user, is_admin: true)
    jwt_token = generate_jwt_token(admin_user.id)


    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateQuestion(input: {
            id: #{question_to_update.id},
            content: "Updated question content",
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
    expect(json_response['data']['updateQuestion']['question']['content']).to eq('Updated question content')
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateQuestion(input: {
            id: #{question_to_update.id},
            content: "Updated question content",
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
    expect(json_response['data']['updateQuestion']['errors']).to eq(['You must be an administrator to update a question'])
  end

  it 'returns an error when user is not logged in' do

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateQuestion(input: {
            id: #{question_to_update.id},
            content: "Updated question content",
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
    expect(json_response['data']['updateQuestion']['errors']).to eq(['Authentication required'])
  end
end
