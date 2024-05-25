require 'rails_helper'
require 'jwt'

RSpec.describe 'UpdateSurveyResponse mutation', type: :request do
  let(:admin_user) { create(:user, is_admin: true) }
  let(:survey_response) { create(:survey_response) }

  it 'updates a survey response when authorized' do
    jwt_token = generate_jwt_token(admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateSurveyResponse(input: {
            id: #{survey_response.id},
            userId: #{survey_response.user_id},
            surveyId: #{survey_response.survey_id},
            responseDate: "#{survey_response.response_date.iso8601}"
          }) {
            surveyResponse {
              id
            }
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateSurveyResponse']['surveyResponse']['id']).to eq(survey_response.id.to_s)
  end

  it 'returns an error when user is not an administrator' do
    non_admin_user = create(:user, is_admin: false)
    jwt_token = generate_jwt_token(non_admin_user.id)

    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateSurveyResponse(input: {
            id: #{survey_response.id},
            userId: #{survey_response.user_id},
            surveyId: #{survey_response.survey_id},
            responseDate: "#{survey_response.response_date.iso8601}"
          }) {
            errors
          }
        }
      GRAPHQL
    }, headers: { 'Authorization' => jwt_token }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateSurveyResponse']['errors']).to eq(["You must be an administrator to update a surveyresponse"])
  end

  it 'returns an error when user is not logged in' do
    post '/graphql', params: {
      query: <<~GRAPHQL
        mutation {
          updateSurveyResponse(input: {
            id: #{survey_response.id},
            userId: #{survey_response.user_id},
            surveyId: #{survey_response.survey_id},
            responseDate: "#{survey_response.response_date.iso8601}"
          }) {
            errors
          }
        }
      GRAPHQL
    }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data']['updateSurveyResponse']['errors']).to eq(['Authentication required'])
  end
end
