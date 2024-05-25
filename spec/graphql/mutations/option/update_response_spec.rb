require 'rails_helper'
require 'jwt'

RSpec.describe Mutations::UpdateOption, type: :request do
  let(:option) { create(:option) }
  let(:admin_user) { create(:user, is_admin: true) }

  it 'updates an existing option' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateOption(input: {
            id: #{option.id},
            content: "New content for the option",
            questionId: #{option.question_id}
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
    expect(json_response['data']['updateOption']['option']['content']).to eq('New content for the option')
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateOption(input: {
            id: #{option.id},
            content: "Updated content",
            questionId: #{option.question_id}
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
    expect(json_response['data']['updateOption']['errors']).to eq(['You must be an administrator to update an option'])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateOption(input: {
            id: #{option.id},
            content: "Updated content",
            questionId: #{option.question_id}
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
    expect(json_response['data']['updateOption']['errors']).to eq(['Authentication required'])
  end
end
