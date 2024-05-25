module Mutations
  class DestroyUser < BaseMutation
    field :id, ID, null: true
    field :errors, [String], null: true

    argument :id, ID, required: true

    def resolve(id:)
      if context[:current_user].nil?
        return {
          user: nil,
          errors: ['You need to login']
        }
      end
      user = User.find(id)
      if user != context[:current_user] && !context[:current_user].is_admin?
        return { errors: ["You are not authorized"] }
      end
      user.destroy
      {
        id: id,
        errors: []
      }

    end
  end
end
