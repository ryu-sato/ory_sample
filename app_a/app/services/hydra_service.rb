class HydraService
  include Singleton

  def initialize
    @config = OryHydraClient::Configuration.new do |config|
      config.debugging = Settings.openid.provider.debugging
      config.server_index = nil # デフォルトの0ではHydraとClientが同一ホストである設定になるため解除する
      config.host = Settings.openid.provider.host
    end
    @client = OryHydraClient::ApiClient.new(@config)
    @admin_client = OryHydraClient::AdminApi.new(@client)
  end

  def active_token?(token, scope = "")
    opts = scope.present? ? { scope: scope } : {}
    introspection = @admin_client.introspect_o_auth2_token(token, opts)

    introspection.active
  end

  def accept_login(login_challenge, subject)
    login_request = HydraService.instance.login_request(login_challenge)
    accept = OryHydraClient::AcceptLoginRequest.new(
      subject: subject
    )
    @admin_client.accept_login_request(login_challenge, body: accept)
  end

  def login_request(login_challenge)
    @admin_client.get_login_request(login_challenge)
  end

  def accept_consent(consent_challenge, grant_scope, grant_access_token_audience)
    accept = OryHydraClient::AcceptConsentRequest.new(
      grant_scope: grant_scope,
      grant_access_token_audience: grant_access_token_audience
    )
    @admin_client.accept_consent_request(consent_challenge, body: accept)
  end

  def consent_request(consent_challenge)
    @admin_client.get_consent_request(consent_challenge)
  end
end
