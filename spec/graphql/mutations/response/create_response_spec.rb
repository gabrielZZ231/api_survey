require 'rails_helper'
require 'jwt'

def generate_jwt_token(user_id)
  secret_key = 'my_secret'
  payload = { user_id: user_id }
  JWT.encode(payload, secret_key, 'HS256')
end

RSpec.describe 'CreateResponse mutation', type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:survey) { create(:survey) }
  let(:survey_response) { create(:survey_response) }
  let(:option) { create(:option) }

  it 'creates a new response' do
    jwt_token = generate_jwt_token(user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createResponse(input: {
            content: "Test Content",
            userId: #{user.id},
            questionId: #{question.id},
            surveyId: #{survey.id},
            surveyResponseId: #{survey_response.id},
            optionIds: [#{option.id}]
          }) {
            response {
              id
              content
              user{
                id
              }
              question{
                id
              }
              survey{
                id
              }
              surveyResponse{
                id
              }
              options{
                id
              }
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createResponse']['response']['content']).to eq('Test Content')
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          createResponse(input: {
            content: "Test Content",
            userId: #{user.id},
            questionId: #{question.id},
            surveyId: #{survey.id},
            surveyResponseId: #{survey_response.id},
            optionIds: [#{option.id}]
          }) {
            response {
              id
              content
              user{
                id
              }
              question{
                id
              }
              survey{
                id
              }
              surveyResponse{
                id
              }
              options{
                id
              }
            }
            errors
          }
        }
      GRAPHQL
    }
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['createResponse']['errors']).to eq(['Authentication required'])
  end
end
