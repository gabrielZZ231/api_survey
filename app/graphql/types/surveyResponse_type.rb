module Types
  class SurveyResponseType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :survey, Types::SurveyType, null: false
    field :responses, [Types::ResponseType], null: false
    field :response_date, GraphQL::Types::ISO8601DateTime, null: true
    field :questions, [Types::QuestionType], null: false
    field :response_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

  end
end
