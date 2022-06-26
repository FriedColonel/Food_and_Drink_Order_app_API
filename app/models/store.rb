class Store < ApplicationRecord
  before_save :email_downcase

  has_many :products, dependent: :delete_all

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true

  has_secure_password

  def random_image image
    update_attribute :image, image
  end

  private
  def email_downcase
    self.email = email.downcase
  end
end
