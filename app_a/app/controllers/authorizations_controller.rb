class AuthorizationsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    raise 'consent challenge is empty' if current_consent_challenge.blank?

    consent_request = HydraService.instance.consent_request(current_consent_challenge)
    accept_consent_and_redirect(consent_request) and return if consent_request.skip

    @consent_challenge = consent_request.challenge
    @user = consent_request.subject
    @client_id = consent_request.client.client_id
    @scope = consent_request.requested_scope
  end
  
  def create
    raise 'consent challenge is empty' if current_consent_challenge.blank?
    redirect_to(HydraService.instance.begin_login_url) and return unless authorize_params[:authorize]

    consent_request = HydraService.instance.consent_request(current_consent_challenge)
    accept_consent_and_redirect(consent_request)
  end

  private
  
  def accept_consent_and_redirect(consent_request)
    completed_request = HydraService.instance.accept_consent(
                          current_consent_challenge,
                          consent_request.requested_scope,
                          consent_request.requested_access_token_audience)

    redirect_to completed_request.redirect_to
  end

  def current_consent_challenge
    params.permit(:consent_challenge).fetch(:consent_challenge, {})
  end
  
  def authorize_params
    params.permit(:authorize)
  end
end
