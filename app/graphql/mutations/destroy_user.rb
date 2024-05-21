# frozen_string_literal: true

module Mutations
  class DestroyUser < BaseMutation
    def ready?(**_args)
      if !context[:current_user]
        raise GraphQL::ExecutionError, "You need to login!"
      else
        true
      end
    end

    field :id, ID, null: true

    argument :id, ID, required: true

    def resolve(id:)
      user = User.find(id)
      if user != context[:current_user] && !context[:current_user].is_admin?
        raise GraphQL::ExecutionError, "You are not authorized!"
      end
      user.destroy
      {
        id: id,
      }
    end
  end
end