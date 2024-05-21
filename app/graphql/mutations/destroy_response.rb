module Mutations
  class DestroyResponse < BaseMutation
    def ready?(**_args)
      if !context[:current_user]
        raise GraphQL::ExecutionError, "You need to login!"
      elsif !context[:current_user].is_admin?
        raise GraphQL::ExecutionError, "You must be an administrator to delete a response!"
      else
        true
      end
    end

    field :id, ID, null: true

    argument :id, ID, required: true

    def resolve(id:)
      response = Response.find(id)
      response.destroy
      {
        id: id,
      }
    end
  end
end