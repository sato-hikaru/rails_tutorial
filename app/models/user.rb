class User < ApplicationRecord
  VALID_EMAILREGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  before_save {email.downcase!}
  validates :name, presence: true, length: { maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAILREGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end
