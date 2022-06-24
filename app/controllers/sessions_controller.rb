class SessionsController < ApplicationController
  def create
    user = User
            .find_by(email: params["user"]["email"])
            .try(:authenticate, params["user"]["password"])

    if user
      loggin user
      render json: {
        value: session,
        status: :create,
        logged_in: true,
        user: user
      }
    else
      render json: { status: 401 }
    end
  end
end
