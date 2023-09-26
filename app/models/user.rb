class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
