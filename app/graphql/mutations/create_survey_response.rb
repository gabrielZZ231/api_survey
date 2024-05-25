class Mutations::CreateSurveyResponse < Mutations::BaseMutation
  field :errors, [String], null: true
  field :survey_response, Types::SurveyResponseType, null: true
  argument :user_id, ID, required: true
  argument :survey_id, ID, required: true

  def resolve(user_id:, survey_id:)
    if context[:current_user].nil?
      return {
        survey_response: nil,
        errors: ['Authentication required']
      }
    elsif !context[:current_user].is_admin?
      return {
        survey_response: nil,
        errors: ['You must be an administrator to create a new surveyresponse']
      }
    end

    survey_response = SurveyResponse.new(user_id: user_id, survey_id: survey_id, response_date: Time.now)

    if survey_response.save
      {
        survey_response: survey_response,
        errors: []
      }
    else
      raise GraphQL::ExecutionError, survey_response.errors.full_messages.join(", ")
    end
  end
end
