class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    user = User.find_by email: params[:email]
    if user&.authenticate params[:password]
      token = JsonWebToken.encode user_id: user.id
      user_info = user.user_info(request.base_url)
      render json: {status: :ok, user_info: user_info, jwt: token, message: "You logged in! Welcome back, #{user.username}"}
    else
      render json: {status: :unauthorized, message: "Log in failed! Username or password invalid!"}
    end
  end

  def show
    user_id = JsonWebToken.decode params[:token]
    if user_id.nil?
      render json: {status: :unauthorized, message: "Log in failed!"}
    else
      user_info = User.get_info_user user_id.first["user_id"]
      render json: {status: :ok, user_info: user_info}
    end
  end
end
