class SurveyResponse < ApplicationRecord
  belongs_to :user
  belongs_to :survey
  has_many :responses, dependent: :destroy

  validates :user_id, :survey_id, presence: true
end
