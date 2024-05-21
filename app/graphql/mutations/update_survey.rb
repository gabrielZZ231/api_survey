module Mutations
  class UpdateSurvey < BaseMutation
    field :survey, Types::SurveyType, null: false

    argument :id, ID, required: true
    argument :title, String, required: true
    argument :user_id, Integer, required: true
    argument :finished, Boolean, required: true

    def resolve(id:, title:, user_id:, finished:)
      if context[:current_user].nil?
        return {
          survey: nil,
          errors: ['Authentication required']
        }
      elsif !context[:current_user].is_admin?
        return {
          survey: nil,
          errors: ['You must be an administrator to update a Survey']
        }
      end
      survey = Survey.find(id)
      if survey.update(title: title, user_id: user_id, finished: finished)
        { survey: survey }
      else
        raise GraphQL::ExecutionError, survey.errors.full_messages.join(", ")
      end
    end
  end
end
