module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    rescue_from Errors::AuthenticationFailed, with: :authentication_failed
    rescue_from Errors::AuthorizationFailed, with: :authorization_failed

    def authorization!(scope = "")
      raise Errors::AuthenticationFailed if access_token.blank?
      raise Errors::AuthorizationFailed unless HydraService.instance.active_token?(access_token, scope)
    end

    private

    def bearer_token
      type, credentials = request.headers['Authorization']&.split
      'Bearer'.casecmp(type) == 0 ? credentials : nil
    end

    def access_token_in_param
      params[:access_token]
    end

    def access_token(allowed_methods = %i[bearer param])
      (allowed_methods.include?(:bearer) && bearer_token) ||
      (allowed_methods.include?(:param) && access_token_in_param)
    end

    def authentication_failed(error)
      logger.warn(error)
      render json: { error: error }, status: :unauthorized
    end

    def authorization_failed(error)
      logger.warn(error)
      render json: { error: error }, status: :forbidden
    end
  end
end
