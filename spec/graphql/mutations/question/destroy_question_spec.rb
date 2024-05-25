require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'DestroyQuestion mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }

  it 'deletes the question when authorized' do
    question_to_delete = create(:question, id: 42)

    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyQuestion(input: {
            id: #{question_to_delete.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyQuestion']['id']).to eq(question_to_delete.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    question_to_delete = create(:question)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyQuestion(input: {
            id: #{question_to_delete.id}
          }) {
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyQuestion']['errors']).to eq(["You must be an administrator to delete a question"])
  end

  it 'returns an error when user is not logged in' do
    question_to_delete = create(:question)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyQuestion(input: {
            id: #{question_to_delete.id}
          })
          {
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyQuestion']['errors']).to eq(['You need to login'])
  end
end
