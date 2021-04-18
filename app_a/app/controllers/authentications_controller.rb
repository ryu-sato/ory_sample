class AuthenticationsController < ApplicationController

  def new
    login_request = HydraService.instance.login_request(current_login_challenge)
    logger.debug('-----login_request begin-----')
    logger.debug(login_request)
    logger.debug('-----login_request end-----')
    if login_request.skip
      logger.debug('already logged in, skip authentication.')
      redirect_to root_path
      return
    end

    @login_challenge = current_login_challenge
    @user = User.new
  end

  def create
    email = user_params[:email]
    raise Errors::AuthenticationFailed unless authenticate(email)

    completed_request = HydraService.instance.accept_login(current_login_challenge, email)
    logger.debug('-----completed_request begin-----')
    logger.debug(completed_request)
    logger.debug('-----completed_request end-----')
    
    redirect_to completed_request.redirect_to
  end

  private

  def authenticate(user)
    true
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :password)
  end

  def current_login_challenge
    params.permit(:login_challenge).fetch(:login_challenge, {})
  end
end
