class AuthorizationsController < ApplicationController
  def authorize
    redirect_to HydraService.instance.begin_login_url
  end

  def callback
    code = authorized_params[:code]
    response = HydraService.instance.issue_token(code)

    save_id_token(response.id_token)

    jwt_payload = JWT.decode(response.id_token, nil, false).first
    authorization = Authorization.find_or_create_by(subject: jwt_payload["sub"])
    if authorization.update(access_token: response.access_token)
      logger.debug("redirect to #{root_path}")
      redirect_to root_path
    else
      logger.debug(authorization.errors)
      raise Errors::AuthorizationFailed
    end
  end
  
  private
  
  def authorized_params
    params.permit(:code)
  end
end
