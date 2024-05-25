require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'UpdateResponse mutation', type: :request do
  let(:user) { create(:user) }

  it 'updates a response when authorized' do
    response_to_update = create(:response)

    jwt_token = generate_jwt_token(user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateResponse(input: {
            id: #{response_to_update.id},
            content: "Updated Response Content",
            userId: #{response_to_update.user_id},
            questionId: #{response_to_update.question_id},
            surveyId: #{response_to_update.survey_id},
            surveyResponseId: #{response_to_update.survey_response_id},
            optionIds: [15, 16]
          }) {
            response {
              id
              content
              user {
                id
              }
              question {
                id
              }
              survey {
                id
              }
              surveyResponse {
                id
              }
              options {
                id
              }
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateResponse']['response']['content']).to eq('Updated Response Content')
  end

  it 'returns an error when user is not logged in' do
    response_to_update = create(:response)
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateResponse(input: {
            id: #{response_to_update.id},
            content: "Updated Response Content",
            userId: 1,
            questionId: #{response_to_update.question_id},
            surveyId: #{response_to_update.survey_id},
            surveyResponseId: #{response_to_update.survey_response_id},
            optionIds: [15, 16]
          }) {
            response {
              id
              content
              user {
                id
              }
              question {
                id
              }
              survey {
                id
              }
              surveyResponse {
                id
              }
              options {
                id
              }
            }
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateResponse']['errors']).to eq(['Authentication required'])
  end
end
