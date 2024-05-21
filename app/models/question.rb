class Question < ApplicationRecord
  belongs_to :survey
  has_many :options, dependent: :destroy
  has_many :responses, dependent: :destroy

  validates :content, :question_type, presence: true

  validate :must_have_at_least_one_response

  def must_have_at_least_one_response
    errors.add(:base, 'must have at least one response') if responses.empty?
  end

end
