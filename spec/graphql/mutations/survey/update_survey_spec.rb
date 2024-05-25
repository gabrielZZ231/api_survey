require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'UpdateSurvey mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'updates a survey when authorized' do
    survey_to_update = create(:survey)

    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateSurvey(input: {
            id: #{survey_to_update.id},
            title: "Updated Survey Title",
            userId: #{survey_to_update.user_id},
            finished: true
          }) {
            survey {
              id
              title
              user{
                id
              }
              finished
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateSurvey']['survey']['title']).to eq('Updated Survey Title')
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)

    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateSurvey(input: {
            id: 20,
            title: "Updated Survey Title",
            userId: 1,
            finished: true
          }) {
            survey {
              id
              title
              user{
                id
              }
              finished
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateSurvey']['errors']).to eq(['You must be an administrator to update a survey'])
  end

  it 'returns an error when user is not logged in' do
    survey_to_update = create(:survey)
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateSurvey(input: {
            id: #{survey_to_update.id},
            title: "Updated Survey Title",
            userId: 1,
            finished: true
          }) {
            survey {
              id
              title
              user{
                id
              }
              finished
            }
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateSurvey']['errors']).to eq(['Authentication required'])
  end
end
