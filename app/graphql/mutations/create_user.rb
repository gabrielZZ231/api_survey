class Mutations::CreateUser < Mutations::BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :is_admin, Boolean, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: true

    def resolve(name:, email:, is_admin:, password:)
      if context[:current_user].nil?
          return {
            user: nil,
            errors: ['Authentication required']
          }
        elsif !context[:current_user].is_admin?
          return {
            user: nil,
            errors: ['You must be an administrator to create a new user']
          }
        end

        existing_user = User.find_by(email: email)

        if existing_user
          return {
            user: existing_user,
            errors: ["User already registered. Please log in instead"]
          }
        end

      user = User.new(name: name, email: email, is_admin: is_admin, password: password)

      if user.save
      {
        user: user,
        errors: []
      }
      else
        raise GraphQL::ExecutionError, user.errors.full_messages.join(", ")
      end
    end
end
