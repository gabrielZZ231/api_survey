class Mutations::CreateOption < Mutations::BaseMutation
  argument :content, String, required: true
  argument :question_id, ID, required: true

  field :option, Types::OptionType, null: true
  field :errors, [String], null: true

  def resolve(content:, question_id:)
      if context[:current_user].nil?
          return {
            option: nil,
            errors: ['Authentication required']
          }
        elsif !context[:current_user].is_admin?
          return {
            option: nil,
            errors: ['You must be an administrator to create a new option']
          }
        end
      option = Option.new(content: content, question_id: question_id)

      if option.save
          {
              option: option,
              errors: []
          }
      else
          {
              option: nil,
              errors: option.errors.full_messages
          }
      end
  end
end
