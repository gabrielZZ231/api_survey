require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'DestroySurveyResponse mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'deletes the survey response when authorized' do
    survey_response_to_delete = create(:survey_response, id: 60)

    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroySurveyResponse(input: {
            id: #{survey_response_to_delete.id}
          }) {
            id
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroySurveyResponse']['id']).to eq(survey_response_to_delete.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    survey_response_to_delete = create(:survey_response, id: 60)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroySurveyResponse(input: {
            id: #{survey_response_to_delete.id}
          }) {
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroySurveyResponse']['errors']).to eq(["You must be an administrator to delete a surveyresponse"])
  end

  it 'returns an error when user is not logged in' do
    survey_response_to_delete = create(:survey_response, id: 50)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroySurveyResponse(input: {
            id: #{survey_response_to_delete.id}
          })
          {
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroySurveyResponse']['errors']).to eq(['You need to login'])
  end
end
