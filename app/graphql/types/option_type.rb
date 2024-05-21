module Types
  class OptionType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: true
    field :question, Types::QuestionType, null: false
    field :response, Types::ResponseType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
