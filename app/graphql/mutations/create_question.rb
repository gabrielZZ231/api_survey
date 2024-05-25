class Mutations::CreateQuestion < Mutations::BaseMutation
  argument :content, String, required: true
  argument :survey_id, ID, required: true
  argument :question_type, String, required: true

  field :question, Types::QuestionType, null: true
  field :errors, [String], null: true

  def resolve(content:, survey_id:, question_type:)
      if context[:current_user].nil?
          return {
            question: nil,
            errors: ['Authentication required']
          }
        elsif !context[:current_user].is_admin?
          return {
            question: nil,
            errors: ['You must be an administrator to create a new question']
          }
        end

      question = Question.new(content: content, survey_id: survey_id, question_type: question_type)

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
