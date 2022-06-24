class User < ApplicationRecord
  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email

  private
  def email_downcase
    self.email = email.downcase
  end
end
