class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all.order('created_at DESC')
    render json: @users
  end

  def show
    @ratings = @user.ratings.all
    @orders = @user.orders.all
    render json: {
      user: @user,
      ratings: @ratings,
      orders: @orders
    }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
  def set_user
    @user = User.find_by id: params[:id]
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :password,
                                 :password_confirmation, :address, :email,
                                 :phone_number, :image)
  end
end
