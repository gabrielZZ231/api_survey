# frozen_string_literal: true

module Mutations
  class UpdateUser < BaseMutation
    field :user, Types::UserType, null: false

    argument :id, ID, required: true
    argument :name, String, required: true
    argument :email, String, required: true
    argument :is_admin, Boolean, required: true
    argument :password, String, required: true

    def resolve(id:, name:, email:, is_admin:, password:)
      if context[:current_user].nil?
        return {
          user: nil,
          errors: ['Authentication required']
        }
      elsif !context[:current_user].is_admin?
        return {
          user: nil,
          errors: ['You must be an administrator to update a new user']
        }
      end
      user = User.find(id)
      if user.update(name: name, email: email, is_admin: is_admin, password: password)
        { user: user }
      else
        raise GraphQL::ExecutionError, user.errors.full_messages.join(", ")
      end
    end
  end
end
