class Mutations::CreateSurveyResponse < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :survey_id, ID, required: true
    argument :response_date, GraphQL::Types::ISO8601DateTime, required: false

    type Types::SurveyResponseType

    def resolve(user_id:, survey_id:)
      if context[:current_user].nil?
        return {
          user: nil,
          errors: ['Authentication required']
        }
      elsif !context[:current_user].is_admin?
        return {
          user: nil,
          errors: ['You must be an administrator to create a new SurveyResponse']
        }
      end

      SurveyResponse.create!(
        user_id: user_id,
        survey_id: survey_id,
      )
    end
end
