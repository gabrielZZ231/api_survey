module Mutations
  class UpdateOption < BaseMutation
    field :option, Types::OptionType, null: true
    field :errors, [String], null: true

    argument :id, ID, required: true
    argument :content, String, required: true
    argument :question_id, ID, required: true

    def resolve(id:, content:, question_id:)
      if context[:current_user].nil?
        return {
          option: nil,
          errors: ['Authentication required']
        }
      elsif !context[:current_user].is_admin?
        return {
          option: nil,
          errors: ['You must be an administrator to update an option']
        }
      end
      option = Option.find(id)
      if option.update(content: content, question_id: question_id)
        { option: option }
      else
        raise GraphQL::ExecutionError, option.errors.full_messages.join(", ")
      end
    end
  end
end
