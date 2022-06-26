# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :store
  has_many :order_products, dependent: :delete_all
  has_many :orders, through: :order_products, dependent: :delete_all
  has_many :ratings, dependent: :delete_all

  def average_rating
    # average = self.ratings.average(:vote)
    update_attribute(:rating, self.ratings.average(:vote))
  end
end
