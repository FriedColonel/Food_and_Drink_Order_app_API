# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  def index
    if params[:category].blank?
      @products = Product.all.order('created_at DESC')
    else
      @category_id = Category.find_by(name: params[:category]).id
      @products = Product.where(:category_id => @category_id).order('created_at DESC')
    end
    # sql = 'SELECT * FROM products'
    # products = ActiveRecord::Base.connection.execute(sql)
    render json: @products
  end

  def show
    sql = "SELECT * FROM products WHERE id = #{params[:id]} LIMIT 1"
    product = ActiveRecord::Base.connection.execute(sql)
    render json: product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
  end

  private
  def set_product
    @product = Product.find_by id: params[:id]
  end

  def product_params
    params.require(:product).permit(:name, :description, :image, :price, :category_id, :store_id)
  end
end
