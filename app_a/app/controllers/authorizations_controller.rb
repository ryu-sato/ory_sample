class AuthorizationsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    raise 'consent challenge is empty' if current_consent_challenge.blank?

    request = HydraService.instance.consent_request(current_consent_challenge)
    if request.skip
      logger.debug('already authorized, skip authorization.')
      completed_request = HydraService.instance.accept_consent(
        current_consent_challenge,
        request.requested_scope,
        request.requested_access_token_audience)

      redirect_to completed_request.redirect_to
    end

    @consent_challenge = request.challenge
    @user = request.subject
    @client_id = request.client.client_id
    @scope = request.requested_scope
  end
  
  def create
    raise 'consent challenge is empty' if current_consent_challenge.blank?
    redirect_to(HydraService.instance.begin_login_url) and return unless authorize_params[:authorize]

    request = HydraService.instance.consent_request(current_consent_challenge)
    completed_request = HydraService.instance.accept_consent(
      current_consent_challenge,
      request.requested_scope,
      request.requested_access_token_audience)

    redirect_to completed_request.redirect_to
  end

  private

  def current_consent_challenge
    params.permit(:consent_challenge).fetch(:consent_challenge, {})
  end
  
  def authorize_params
    params.permit(:authorize)
  end
end
