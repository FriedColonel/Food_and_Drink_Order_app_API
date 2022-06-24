class User < ApplicationRecord
  before_save :email_downcase

  has_many :orders

  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password

  private
  def email_downcase
    self.email = email.downcase
  end
end
