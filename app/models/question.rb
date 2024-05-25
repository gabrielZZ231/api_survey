class Question < ApplicationRecord
  belongs_to :survey
  has_many :options, dependent: :destroy
  has_many :responses, through: :options

  validates :content, :question_type, presence: true
  validate :at_least_one_response, on: :update

  private

  def at_least_one_response
    return unless responses.any?(&:changed?)
    errors.add(:base, 'A question must have at least one associated response')
  end
end
