class Option < ApplicationRecord
  belongs_to :question
  belongs_to :response, dependent: :destroy

  validates :content, presence: true
end
