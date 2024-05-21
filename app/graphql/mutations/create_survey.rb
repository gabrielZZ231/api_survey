class Mutations::CreateSurvey < Mutations::BaseMutation
  argument :title, String, required: true
  argument :user_id, ID, required: true
  argument :finished, Boolean, required: false

  field :survey, Types::SurveyType, null: false
  field :errors, [String], null: false

  def resolve(title:, user_id:, finished: false)
      if context[:current_user].nil?
          return {
            survey: nil,
            errors: ['Authentication required']
          }
        elsif !context[:current_user].is_admin?
          return {
            survey: nil,
            errors: ['You must be an administrator to create a new Survey']
          }
        end

      survey = Survey.new(title: title, user_id: user_id, finished: finished)

      if survey.save
          {
              survey: survey,
              errors: []
          }
      else
          {
              survey: nil,
              errors: survey.errors.full_messages
          }
      end
  end
end
