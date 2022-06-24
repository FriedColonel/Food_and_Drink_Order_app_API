# frozen_string_literal: true

class ApplicationController < ActionController::API
  def loggin user
    session[:user_id] = user.id
    session[:cart] = []
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id] if session[:user_id]
  end

  def checkout product
    session[:cart].delete product
  end

  def add_to_cart product
    session[:cart] << product
  end

  def loggout
    session[:user_id] = nil
    session[:cart] = nil
  end
end
