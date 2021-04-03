module Api
  module Errors
    class BaseError < StandardError
      attr_reader :code

      def initialize(code: nil, message: nil)
        @code = code
        super(message)
      end
    end

    class AuthenticationFailed < BaseError
      def initialize(message = 'AuthenticationFailed failed.')
        super(code: 401, message: message)
      end
    end

    class AuthorizationFailed < BaseError
      def initialize(message = 'Authorization failed.')
        super(code: 403, message: message)
      end
    end
  end

  class ApiController < ApplicationController
    rescue_from Api::Errors::AuthenticationFailed, with: :authentication_failed
    rescue_from Api::Errors::AuthorizationFailed, with: :authorization_failed

    def authorization!(scope = "")
      raise Api::Errors::AuthenticationFailed if access_token.blank?
      raise Api::Errors::AuthorizationFailed unless HydraService.instance.active_token?(access_token, scope)
    end

    private

    def bearer_token
      type, credentials = request.headers['Authorization']&.split
      'Bearer'.casecmp(type) == 0 ? credentials : nil
    end

    def access_token_in_body
      request.body&.access_token
    end

    def access_token_in_param
      params[:access_token]
    end

    def access_token(allowed_methods = %i[bearer body query])
      (allowed_methods.include?(:bearer) && bearer_token) ||
      (allowed_methods.include?(:body) && access_token_in_body) ||
      (allowed_methods.include?(:query) && access_token_in_param)
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
