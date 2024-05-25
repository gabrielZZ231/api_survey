require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'DestroySurvey mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'deletes the survey when authorized' do
    survey_to_delete = create(:survey, id: 42)

    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroySurvey(input: {
            id: #{survey_to_delete.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroySurvey']['id']).to eq(survey_to_delete.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    survey_to_delete = create(:survey)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroySurvey(input: {
            id: #{survey_to_delete.id}
          }) {
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroySurvey']['errors']).to eq(["You must be an administrator to delete a survey"])
  end

  it 'returns an error when user is not logged in' do
    survey_to_delete = create(:survey)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroySurvey(input: {
            id: #{survey_to_delete.id}
          })
          {
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroySurvey']['errors']).to eq(['You need to login'])
  end
end
