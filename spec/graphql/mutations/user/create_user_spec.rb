require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'CreateUser mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'creates a new user' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createUser(input: {
            name: "User",
            email: "new@ex.com",
            isAdmin: false,
            password: "senha123"
          }) {
            user {
              id
              name
              email
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token}

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createUser']['user']['email']).to eq('new@ex.com')
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createUser(input: {
            name: "User",
            email: "new@ex.com",
            isAdmin: false,
            password: "senha123"
          }) {
            user {
              id
              name
              email
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createUser']['errors']).to eq(['You must be an administrator to create a new user'])
  end

  it 'returns an error when user is not logged in' do

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createUser(input: {
            name: "User",
            email: "new@ex.com",
            isAdmin: false,
            password: "senha123"
          }) {
            user {
              id
              name
              email
            }
            errors
          }
        }
      GRAPHQL
    }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createUser']['errors']).to eq(['Authentication required'])
  end
end
