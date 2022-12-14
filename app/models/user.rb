class User < ApplicationRecord
  before_save :email_downcase

  has_many :orders, dependent: :delete_all
  has_many :ratings, dependent: :delete_all

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true

  has_secure_password

  private
  def email_downcase
    self.email = email.downcase
  end
end
