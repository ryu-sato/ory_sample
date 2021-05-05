class ApplicationController < ActionController::Base
  rescue_from Errors::AuthenticationFailed, with: :authentication_failed
  rescue_from OryHydraClient::ApiError, with: :handle_hydra_error

  private

  def authentication_failed(error)
    logger.warn(error)
    redirect_to HydraService.instance.begin_login_url
  end

  def handle_hydra_error(error)
    logger.warn(error)
    raise Errors::AuthenticationFailed if Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized] == error.code
    raise error
  end

  def save_id_token(id_token)
    cookies[:id_token] = id_token
  end
  
  def delete_id_token
    cookies.delete(:id_token)
  end
  
  def current_id_token
    cookies[:id_token]
  end

  def authenticate!
    raise Errors::AuthenticationFailed if current_id_token.blank?
    raise Errors::AuthenticationFailed unless HydraService.instance.id_token_active?(current_id_token)
  end

  def current_user
    return "" if current_id_token.blank?

    jwt_paylaod = JWT.decode(current_id_token, nil, false).first
    User.find(jwt_paylaod["sub"])
  end
end
