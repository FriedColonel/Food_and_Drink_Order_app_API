class SessionsController < ApplicationController
  def create
    if (params[:option] == "user")
      user = User
              .find_by(email: params["email"])
              .try(:authenticate, params["password"])

      if user
        session[:user_id] = user.id
        render json: {
          logged_in: true,
          user: user
        }
      else
        render json: { status: 401 }
      end
    end

    if (params[:option] == "store")
      store = Store.find_by(email: params["email"])
                    .try(:authenticate, params["password"])
      if store
        session[:store_id] = store.id
        render json: {
          logged_in: true,
          store: store
        }
      else
        render json: { status: 401 }
      end
    end
  end
end
