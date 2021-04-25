class SessionsController < ApplicationController

  def new
    redirect_to :root if current_user
  end

  def create
    user = User.find_by(email: authentication_params[:email])
    raise Errors::AuthenticationFailed if user.blank?
    raise Errors::AuthenticationFailed unless user.authenticate(authentication_params[:password])

    log_in(user)
    redirect_to :root
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end

  private

  def authentication_params
    params.permit(:email, :password)
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
