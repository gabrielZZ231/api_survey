class Response < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :survey
  belongs_to :survey_response
  has_many :options, dependent: :destroy

  validates :content, :user_id, :question_id, :survey_id, :survey_response_id, presence: true
  after_create :create_new_survey_response

  private

  def create_new_survey_response
    user = self.survey_response.user
    survey = self.survey_response.survey
    SurveyResponse.create(user: user, survey: survey, response_date: Time.now)
  end
end
