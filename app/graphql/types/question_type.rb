# frozen_string_literal: true

module Types
  class QuestionType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: true
    field :question_type, String, null: true
    field :survey, Types::SurveyType, null: false
    field :options, [Types::OptionType], null: true
    field :responses, [Types::ResponseType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
