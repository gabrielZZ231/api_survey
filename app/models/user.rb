class User < ApplicationRecord
    has_many :surveys, foreign_key: :user_id, dependent: :destroy


    validates :name, :email, presence: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    has_secure_password
end
