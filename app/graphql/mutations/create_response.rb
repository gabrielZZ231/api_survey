class Mutations::CreateResponse < Mutations::BaseMutation
    argument :content, String, required: true
    argument :user_id, ID, required: true
    argument :question_id, ID, required: true
    argument :survey_id, ID, required: true
    argument :survey_response_id, ID, required: true
    argument :option_ids, [ID], required: false

    field :response, Types::ResponseType, null: false
    field :errors, [String], null: false

    def resolve(content:, user_id:, question_id:, survey_id:, survey_response_id:, option_ids:)
        if context[:current_user].nil?
            return {
              response: nil,
              errors: ['Authentication required']
            }
          end

        options = Option.where(id: option_ids)
        response = Response.new(content: content, user_id: user_id, question_id: question_id, survey_id: survey_id, survey_response_id: survey_response_id, options: options)

        if response.save
            {
                response: response,
                errors: []
            }
        else
            {
                response: nil,
                errors: response.errors.full_messages
            }
        end
    end
end
