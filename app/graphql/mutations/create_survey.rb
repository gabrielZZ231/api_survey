class Mutations::CreateSurvey < Mutations::BaseMutation
  argument :title, String, required: true
  argument :user_id, ID, required: true
  argument :finished, Boolean, required: false

  field :survey, Types::SurveyType, null: true
  field :errors, [String], null: true

  def resolve(title:, user_id:, finished: false)
      if context[:current_user].nil?
          return {
            survey: nil,
            errors: ['Authentication required']
          }
        elsif !context[:current_user].is_admin?
          return {
            survey: nil,
            errors: ['You must be an administrator to create a new survey']
          }
        end

      survey = Survey.new(title: title, user_id: user_id, finished: finished)

      if survey.save
          {
              survey: survey,
              errors: []
          }
      else
        raise GraphQL::ExecutionError, user.errors.full_messages.join(", ")
      end
  end
end
