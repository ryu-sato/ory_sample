class AuthorizationsController < ApplicationController
  def authorize
    redirect_to HydraService.instance.begin_login_url
  end

  def callback
    code = authorized_params[:code]
    response = HydraService.instance.issue_token(code)

    introspection = HydraService.instance.introspect_token(response.access_token)
    authorization = Authorization.find_or_create_by(subject: introspection.sub)
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
