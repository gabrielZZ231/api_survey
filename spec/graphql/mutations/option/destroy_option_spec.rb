require 'rails_helper'
require 'jwt'

RSpec.describe Mutations::DestroyOption, type: :request do
  let(:option) { create(:option) }
  let(:admin_user) { create(:user, is_admin: true) }

  it 'destroys an existing option' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyOption(input: {
            id: #{option.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyOption']['id']).to eq(option.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyOption(input: {
            id: #{option.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyOption']['errors']).to eq(['You must be an administrator to delete an option'])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          destroyOption(input: {
            id: #{option.id}
          }) {
            id
            errors
          }
        }
      GRAPHQL
    }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['destroyOption']['errors']).to eq(['Authentication required'])
  end
end
