require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'UpdateUser mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'updates an existing user' do
    user_to_update = create(:user, id: 2)

    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateUser(input: {
            id: #{user_to_update.id},
            name: "gabriel",
            email: "g@321g.com",
            isAdmin: false,
            password: "123456"
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
    expect(json_response['data']['updateUser']['user']['email']).to eq('g@321g.com')
    expect(json_response['data']['updateUser']['errors']).to be_nil
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)

    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateUser(input: {
            id: 20,
            name: "gabriel",
            email: "g@321g.com",
            isAdmin: false,
            password: "123456"
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
    expect(json_response['data']['updateUser']['errors']).to eq(['You must be an administrator to update a new user'])  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateUser(input: {
            id: 3,
            name: "gabriel",
            email: "g@321g.com",
            isAdmin: false,
            password: "123456"
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
    expect(json_response['data']['updateUser']['errors']).to eq(['Authentication required'])
  end
end
