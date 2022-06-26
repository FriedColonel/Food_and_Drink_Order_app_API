class StoresController < ApplicationController
  before_action :set_store, only: [:show, :update, :destroy]

  def index
    @stores = Store.all.limit(10).order('created_at DESC')
    stores = []
    @stores.each do |store|
      stores << store.as_json.to_hash
      stores.last[:products] = store.products.all.limit(3)
    end
    render json: stores
  end

  def show
    @products = @store.products.order('rating DESC')
    render json: {
      store: @store,
      products: @products
    }
  end

  def create
    @store = Store.new(store_params)

    if @store.save
      render json: @store, status: :created, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  def update
    if @store.update(store_params)
      render json: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @store.destroy
  end

  private
  def set_store
    @store = Store.find_by id: params[:id]
  end

  def store_params
    params.require(:store).permit(:store_name, :store_address, :email, :password, :password_confirmation, :image)
  end
end
