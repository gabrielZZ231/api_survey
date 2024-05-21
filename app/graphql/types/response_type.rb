# frozen_string_literal: true

module Types
  class ResponseType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: true
    field :user, Types::UserType, null: false
    field :question, Types::QuestionType, null: false
    field :survey, Types::SurveyType, null: false
    field :survey_response, Types::SurveyResponseType, null: false
    field :options, [Types::OptionType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
