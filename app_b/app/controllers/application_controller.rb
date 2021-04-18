module Errors
  class BaseError < StandardError
    attr_reader :code

    def initialize(code: nil, message: nil)
      @code = code
      super(message)
    end
  end

  class AuthenticationFailed < BaseError
    def initialize(message = 'Authentication failed.')
      super(code: 401, message: message)
    end
  end

  class AuthorizationFailed < BaseError
    def initialize(message = 'Authorization failed.')
      super(code: 403, message: message)
    end
  end
end

class ApplicationController < ActionController::Base
  rescue_from Errors::AuthenticationFailed, with: :authentication_failed
  rescue_from Errors::AuthorizationFailed, with: :authorization_failed
  rescue_from OryHydraClient::ApiError, with: :handle_hydra_error

  private

  def authentication_failed(error)
    logger.warn(error)
    redirect_to HydraService.instance.begin_login_url
  end

  def authorization_failed(error)
    logger.warn(error)
    redirect_to HydraService.instance.begin_login_url
  end

  def handle_hydra_error(error)
    logger.warn(error)
    raise Errors::AuthenticationFailed if Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized] == error.code
    raise error
  end
end
