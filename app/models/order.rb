class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :delete_all
  has_many :products, through: :order_products

  def get_total
    @total_price ||= order_products.includes(:product).reduce(0) do |sum, l_prod|
      sum + (l_prod.quantity * l_prod.product.price)
    end
    update_attribute :total, @total_price
  end
end
