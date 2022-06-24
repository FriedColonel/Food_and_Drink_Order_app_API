# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api' do
    resources :sessions, only: [:create]
    resources :categories, only: [:index]
    resources :products
    resources :users
    resources :orders
    resources :order_products
  end
end
