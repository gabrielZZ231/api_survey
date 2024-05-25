require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'DestroyUser mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'deletes the user account when authorized' do
    user_to_delete = create(:user, id: 42)

    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyUser(input: {
            id: #{user_to_delete.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyUser']['id']).to eq(user_to_delete.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    user_to_delete = create(:user)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyUser(input: {
            id: #{user_to_delete.id}
          }) {
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyUser']['errors']).to eq(['You are not authorized'])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyUser(input: {
            id: 8
          })
          {
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyUser']['errors']).to eq(['You need to login'])
  end
end
