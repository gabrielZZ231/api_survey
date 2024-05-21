class Mutations::CreateQuestion < Mutations::BaseMutation
  argument :content, String, required: true
  argument :survey_id, ID, required: true
  argument :question_type, String, required: true
  argument :option_ids, [ID], required: false

  field :question, Types::QuestionType, null: false
  field :errors, [String], null: false

  def resolve(content:, survey_id:, question_type:, option_ids:)
      if context[:current_user].nil?
          return {
            question: nil,
            errors: ['Authentication required']
          }
        elsif !context[:current_user].is_admin?
          return {
            question: nil,
            errors: ['You must be an administrator to create a new Question']
          }
        end

      options = Option.where(id: option_ids)
      question = Question.new(content: content, survey_id: survey_id, question_type: question_type, options: options)

      if question.save
          {
              question: question,
              errors: []
          }
      else
          {
              question: nil,
              errors: question.errors.full_messages
          }
      end
  end
end
