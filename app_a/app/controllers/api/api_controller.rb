module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    rescue_from Errors::AuthenticationFailed, with: :render_authentication_failed
    rescue_from Errors::AuthorizationFailed, with: :render_authorization_failed

    def authorization!(scope = "")
      raise Errors::AuthenticationFailed if access_token.blank?
      raise Errors::AuthorizationFailed unless HydraService.instance.active_token?(access_token, scope)
    end

    def render_not_found(error = :not_found)
      logger.warn(error)
      render json: { error: :not_found }, status: :not_found
    end

    def current_user
      return "" if access_token.blank?
      introspection = HydraService.instance.introspect_token(access_token)

      User.find_by(id: introspection.sub)
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

    def render_authentication_failed(error)
      logger.warn(error)
      render json: { error: error }, status: :unauthorized
    end

    def render_authorization_failed(error)
      logger.warn(error)
      render json: { error: error }, status: :forbidden
    end
  end
end
