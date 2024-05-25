require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'CreateSurveyResponse mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }
  let(:survey) { create(:survey) }

  it 'creates a new survey response' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createSurveyResponse(input: {
            userId: #{admin_user.id},
            surveyId: #{survey.id}
          }) {
            surveyResponse {
              id
              user{
                id
              }
              survey{
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
    expect(json_response['data']['createSurveyResponse']['surveyResponse']['user']['id']).to eq(admin_user.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createSurveyResponse(input: {
            userId: #{non_admin_user.id},
            surveyId: #{survey.id}
          }) {
            surveyResponse {
              id
              user{
                id
              }
              survey{
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
    expect(json_response['data']['createSurveyResponse']['errors']).to eq(['You must be an administrator to create a new surveyresponse'])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createSurveyResponse(input: {
            userId: #{admin_user.id},
            surveyId: #{survey.id}
          }) {
            surveyResponse {
              id
              user{
                id
              }
              survey{
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
    expect(json_response['data']['createSurveyResponse']['errors']).to eq(['Authentication required'])
  end
end
