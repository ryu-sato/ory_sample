module Sso
  class AuthenticationsController < ApplicationController

    def new
      login_request = HydraService.instance.login_request(current_login_challenge)
      accept_login_and_redirect(login_request.subject) and return if login_request.skip

      @login_challenge = current_login_challenge
    end

    def create
      user = User.find_by(email: authentication_params[:email])
      raise Errors::AuthenticationFailed if user.blank?
      raise Errors::AuthenticationFailed unless user.authenticate(authentication_params[:password])

      accept_login_and_redirect(user.id.to_s)
    end
    
    def destroy
      HydraService.instance.log_out(current_user)
      delete_id_token

      redirect_to root_path
    end

    private
    
    def accept_login_and_redirect(subject)
      completed_request = HydraService.instance.accept_login(current_login_challenge, subject)
      redirect_to completed_request.redirect_to
    end

    def authentication_params
      params.permit(:email, :password)
    end

    def current_login_challenge
      params.permit(:login_challenge).fetch(:login_challenge, {})
    end
  end
end
