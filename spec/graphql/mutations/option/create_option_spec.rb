require 'rails_helper'
require 'jwt'

RSpec.describe Mutations::CreateOption, type: :request do
  let(:question) { create(:question) }
  let(:admin_user) { create(:user, is_admin: true) }

  it 'creates a new option' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createOption(input: {
            content: "Paris",
            questionId: #{question.id}
          }) {
            option {
              id
              content
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createOption']['option']['content']).to eq('Paris')
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createOption(input: {
            content: "Berlin",
            questionId: #{question.id}
          }) {
            option {
              id
              content
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createOption']['errors']).to eq(['You must be an administrator to create a new option'])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createOption(input: {
            content: "Madrid",
            questionId: #{question.id}
          }) {
            option {
              id
              content
            }
            errors
          }
        }
      GRAPHQL
    }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createOption']['errors']).to eq(['Authentication required'])
  end
end
