class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    render json: @orders
  end

  # GET api/orders/:id
  def show
    lines = @order.order_products.all
    @lines = []
    lines.each do |line|
      @lines << line.as_json.to_hash
      product = line.product
      @lines.last[:product_name] = product.name
      @lines.last[:product_image] = product.image
      @lines.last[:product_price] = product.price
    end
    render json: {
      order: @order,
      line: @lines
    }
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
  end

  def pending_orders
    @orders = Order.where(status: false).order('updated_at DESC')
    render json: @orders
  end

  private
  def set_order
    @order = Order.find_by id: params[:id]
    return if @order
    render json: {error: "Not found"}
  end

  def order_params
    params.require(:order).permit(:status, :user_id, :total, :receiver_name, :receiver_phone)
  end
end
