# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :destroy_option, mutation: Mutations::DestroyOption
    field :destroy_question, mutation: Mutations::DestroyQuestion
    field :destroy_response, mutation: Mutations::DestroyResponse
    field :destroy_survey, mutation: Mutations::DestroySurvey
    field :destroy_user, mutation: Mutations::DestroyUser
    field :destroy_survey_response, mutation: Mutations::DestroySurveyResponse
    field :update_option, mutation: Mutations::UpdateOption
    field :update_question, mutation: Mutations::UpdateQuestion
    field :update_response, mutation: Mutations::UpdateResponse
    field :update_survey, mutation: Mutations::UpdateSurvey
    field :update_user, mutation: Mutations::UpdateUser
    field :update_survey_response, mutation: Mutations::UpdateSurveyResponse
    field :create_user, mutation: Mutations::CreateUser
    field :create_survey, mutation: Mutations::CreateSurvey
    field :create_question, mutation: Mutations::CreateQuestion
    field :create_option, mutation: Mutations::CreateOption
    field :create_response, mutation: Mutations::CreateResponse
    field :create_survey_response, mutation: Mutations::CreateSurveyResponse
    field :login, mutation: Mutations::Login
  end
end
