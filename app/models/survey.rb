class Survey < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :survey_responses

  validates :title, presence: true, length: { maximum: 100 }
end
