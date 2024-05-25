class Option < ApplicationRecord
  belongs_to :question
  belongs_to :response,optional: true

  validates :content, presence: true
end
