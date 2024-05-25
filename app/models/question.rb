class Question < ApplicationRecord
  belongs_to :survey
  has_many :options, dependent: :destroy
  has_many :responses, through: :options

  validates :content, :question_type, presence: true

end
