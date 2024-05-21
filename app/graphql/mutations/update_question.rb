module Mutations
  class UpdateQuestion < BaseMutation
    field :question, Types::QuestionType, null: false

    argument :id, ID, required: true
    argument :content, String, required: true
    argument :survey_id, ID, required: true
    argument :question_type, String, required: true
    argument :option_ids, [ID], required: false

    def resolve(id:, content:, survey_id:, question_type:, option_ids:)
      if context[:current_user].nil?
        return {
          question: nil,
          errors: ['Authentication required']
        }
      elsif !context[:current_user].is_admin?
        return {
          question: nil,
          errors: ['You must be an administrator to update a Question']
        }
      end
      question = Question.find(id)
      options = Option.where(id: option_ids)
      if question.update(content: content, survey_id: survey_id, question_type: question_type, options: options)
        { question: question }
      else
        raise GraphQL::ExecutionError, question.errors.full_messages.join(", ")
      end
    end
  end
end
