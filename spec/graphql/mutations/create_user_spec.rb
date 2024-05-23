# spec/requests/graphql/create_user_spec.rb
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
    }, headers: { 'Authorization' => "#{jwt_token}" }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createUser']['user']['email']).to eq('new@ex.com')
  end
end
