module Types
  class SurveyResultType < Types::BaseObject
    field :question, String, null: false
    field :options, [String], null: true
    field :response_count, Integer, null: false
  end
end
