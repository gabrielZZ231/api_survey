module Mutations
  class UpdateResponse < BaseMutation
    field :response, Types::ResponseType, null: true
    field :errors, [String], null: true

    argument :id, ID, required: true
    argument :content, String, required: true
    argument :user_id, ID, required: true
    argument :question_id, ID, required: true
    argument :survey_id, ID, required: true
    argument :survey_response_id, Integer, required: true
    argument :option_ids, [ID], required: false

    def resolve(id:, content:, user_id:, question_id:, survey_id:, survey_response_id:, option_ids:)
      if context[:current_user].nil?
        return {
          response: nil,
          errors: ['Authentication required']
        }
      end
      response = Response.find(id)
      options = Option.where(id: option_ids)
      if response.update(content: content, user_id: user_id, question_id: question_id, survey_id: survey_id, survey_response_id: survey_response_id, options: options)
        { response: response }
      else
        raise GraphQL::ExecutionError, response.errors.full_messages.join(", ")
      end
    end
  end
end
