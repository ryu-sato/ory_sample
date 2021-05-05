module Sso
  class SessionsController < ApplicationController

    def callback
      code = authorized_params[:code]
      response = HydraService.instance.issue_token(code)

      save_id_token(response.id_token)
      redirect_to root_path
    end

    private

    def authentication_params
      params.permit(:email, :password)
    end

    def authorized_params
      params.permit(:code)
    end

    def log_in(user)
      session[:user_id] = user.id
    end
  end
end
