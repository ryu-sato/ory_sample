class ApplicationController < ActionController::Base
  rescue_from Errors::AuthenticationFailed, with: :authentication_failed

  def authenticate!
    raise Errors::AuthenticationFailed if session[:user_id].blank?
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  private

  def authentication_failed(error)
    logger.warn(error)
    redirect_to login_path
  end
end
