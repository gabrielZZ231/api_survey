class Mutations::UpdateSurveyResponse < Mutations::BaseMutation
  argument :id, ID, required: true
  argument :user_id, ID, required: true
  argument :survey_id, ID, required: true
  argument :response_date, GraphQL::Types::ISO8601DateTime, required: false

  type Types::SurveyResponseType

  def resolve(id:, user_id:, survey_id:, response_date:)
    if context[:current_user].nil?
      return {
        survey: nil,
        errors: ['Authentication required']
      }
    elsif !context[:current_user].is_admin?
      return {
        survey: nil,
        errors: ['You must be an administrator to update a SurveyResponse']
      }
    end
    survey_response = SurveyResponse.find(id)
    survey_response.update(
      user_id: user_id,
      survey_id: survey_id,
      response_date: response_date
    )
    survey_response
  end
end
