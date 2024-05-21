module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false

    def users
      authenticate_user
      authorize_admin
      User.all
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end

    def user(id:)
      authenticate_user
      authorize_admin
      user = User.find(id)
      if user
        user
      else
        raise GraphQL::ExecutionError, "User not found with id #{id}"
      end
    end


    field :surveys, [Types::SurveyType], null: false

    def surveys
      authenticate_user
      Survey.all
    end

    field :survey, Types::SurveyType, null: false do
      argument :id, ID, required: true
    end

    def survey(id:)
      authenticate_user
      authorize_admin
      survey = Survey.find(id)
      if survey
        survey
      else
        raise GraphQL::ExecutionError, "Survey not found with id #{id}"
      end
    end

    field :questions, [Types::QuestionType], null: false

    def questions
      authenticate_user
      Question.all
    end

    field :question, Types::QuestionType, null: false do
      argument :id, ID, required: true
    end

    def question(id:)
      authenticate_user
      Question.find(id)
    end

    field :responses, [Types::ResponseType], null: false

    def responses
      authenticate_user
      authorize_admin
      Response.all
    end

    field :response, Types::ResponseType, null: false do
      argument :id, ID, required: true
    end

    def response(id:)
      authenticate_user
      authorize_admin
      Response.find(id)
    end

    field :options, [Types::OptionType], null: false

    def options
      authenticate_user
      Option.all
    end

    field :option, Types::OptionType, null: false do
      argument :id, ID, required: true
    end

    def option(id:)
      authenticate_user
      Option.find(id)
    end

    field :survey_responses, [Types::SurveyResponseType], null: false

    def survey_responses
      authenticate_user
      authorize_admin
      SurveyResponse.all
    end

    field :survey_response, Types::SurveyResponseType, null: false do
      argument :id, ID, required: true
    end

    def survey_response(id:)
      authenticate_user
      authorize_admin
      survey_response = SurveyResponse.find(id)
      if survey_response
        survey_response
      else
        raise GraphQL::ExecutionError, "SurveyResponse not found with id #{id}"
      end
    end

    field :survey_results, [Types::SurveyResultType], null: true do
      argument :survey_id, ID, required: true
    end

    def survey_results(survey_id:)
      authenticate_user
      survey = Survey.find(survey_id)
      results = []
      survey.questions.each do |question|
        question.responses.each do |response|
          option_contents = response.options.map(&:content)
          response_count = question.responses.count
          results << { question: question.content, response: response.content, options: option_contents, response_count: response_count }
        end
      end
      results
    end

    private

    def authenticate_user
      return if context[:current_user].present?

      raise GraphQL::ExecutionError, 'Authentication required'
    end

    def authorize_admin
      return if context[:current_user].is_admin?

      raise GraphQL::ExecutionError, 'You must be an administrator!'
    end
  end
end
