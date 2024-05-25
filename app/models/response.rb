  class Response < ApplicationRecord
    belongs_to :user
    belongs_to :survey
    belongs_to :survey_response
    belongs_to :question
    has_many :options, dependent: :destroy
    validates :content, :user_id, :question_id, :survey_id, presence: true
  end
