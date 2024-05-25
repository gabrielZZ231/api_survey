require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'DestroyResponse mutation', type: :request do
  let(:user) { create(:user) }

  it 'deletes a response when authorized' do
    response_to_delete = create(:response)

    jwt_token = generate_jwt_token(user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyResponse(input: {
            id: #{response_to_delete.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyResponse']['id']).to eq(response_to_delete.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    response_to_delete = create(:response)
    user.update(is_admin: false)

    jwt_token = generate_jwt_token(user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyResponse(input: {
            id: #{response_to_delete.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyResponse']['errors']).to eq(['You must be an administrator to delete a response'])
  end
end
