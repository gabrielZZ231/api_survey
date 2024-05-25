class Option < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :response,optional: true

  validates :content, presence: true
end
