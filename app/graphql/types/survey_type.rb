module Types
  class SurveyType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: true
    field :user, Types::UserType, null: false
    field :questions, [Types::QuestionType], null: false
    field :finished, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :survey_finished_count, Integer, null: false
    field :survey_not_finished_count, Integer, null: false

    def survey_finished_count
      SurveyResponse.joins(:survey).where(surveys: { finished: true }).count
    end

    def survey_not_finished_count
      SurveyResponse.joins(:survey).where(surveys: { finished: false }).count
    end


  end
end
