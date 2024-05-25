module Mutations
  class DestroyOption < BaseMutation
    field :id, ID, null: true
    field :errors, [String], null: true

    argument :id, ID, required: true

    def resolve(id:)
      option = Option.find(id)
      if context[:current_user].nil?
        return {
          id: nil,
          errors: ["Authentication required"]
        }
      end

      if !context[:current_user].is_admin?
        return {
          id: nil,
          errors: ['You must be an administrator to delete an option']
        }
      end

      option.destroy
      {
        id: id,
        errors: []
      }
    end
  end
end
