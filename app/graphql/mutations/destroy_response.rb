module Mutations
  class DestroyResponse < BaseMutation
    field :id, ID, null: true
    field :errors, [String], null: true

    argument :id, ID, required: true

    def resolve(id:)
      response = Response.find(id)

      if context[:current_user].nil?
        return {
          id: nil,
          errors: ['You need to login']
        }
      end

      if !context[:current_user].is_admin?
        return {
          id: nil,
          errors: ['You must be an administrator to delete a response']
        }
      end

      response.destroy

      {
        id: id,
        errors: []
      }
    end
  end
end
