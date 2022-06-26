class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :update, :destroy]

  def index
    @ratings = Rating.all
    render json: @ratings
  end

  def show
    render json: @rating
  end

  def create
    @rating = Rating.new(rating_params)
    if @rating.save
      # @product = Product.find_by id: params[:product_id]
      # @product.average_rating
      render json: @rating
    else
      render json: @rating.errors, status: :unprocessable_entity
    end
  end

  def update
    if @rating.update(rating_params)
      # @product = Product.find_by id: params[:product_id]
      # @product.average_rating
      render json: @rating
    else
      render json: @rating.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @rating.destroy
  end

  private
  def set_rating
    @rating = Rating.find_by id: params[:id]
  end

  def rating_params
    params.require(:rating).permit(:user_id, :vote, :product_id, :comment)
  end
end
