class OrderProductsController < ApplicationController
  before_action :order_product_params, only: [:show, :destroy, :update]

  def index
    @order_products = Oder_product.all
    render json: @order_products
  end

  def show
    render json: @order_product
  end

  def create
    @order_product = Oder_product.new(order_product_params)
    if @order_product.save
      render json: @order_product
    else
      render json: @order_product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order_product.update(order_product_params)
      render json: @order_product
    else
      render json: @order_product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order_product.destroy
  end

  private
  def set_order_product
    @order_product = Oder_product.find_by id: params[:id]
  end

  def order_product_params
    params.require(:order_product).permit(:order_id, :product_id)
  end
end
