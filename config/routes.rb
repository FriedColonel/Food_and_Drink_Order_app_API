# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api' do
    get 'categories/index'
    resources :products
  end
end
