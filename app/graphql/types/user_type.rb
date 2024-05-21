# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :email, String, null: true
    field :is_admin, Boolean, null: true
    field :password_digest, String, null: true
    field :surveys, [Types::SurveyType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :survey_finished_count, Integer, null: false
    field :survey_not_finished_count, Integer, null: false
    field :survey_count, Integer, null: false

    def survey_count
      object.surveys.count
    end

    def survey_finished_count
      object.surveys.select { |survey| survey.finished }.count
    end

    def survey_not_finished_count
      object.surveys.count - survey_finished_count
    end

  end
end
