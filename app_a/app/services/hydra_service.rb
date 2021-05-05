class HydraService
  include Singleton

  CLIENT_ID = Settings.openid.client_id
  REDIRECT_URI = Settings.openid.redirect_uri

  def initialize
    admin_config = OryHydraClient::Configuration.new do |config|
      config.debugging = Settings.openid.provider.debugging
      config.server_index = nil # デフォルトの0ではHydraとClientが同一ホストである設定になるため解除する
      config.host = Settings.openid.provider.admin_host
    end
    admin_api_client = OryHydraClient::ApiClient.new(admin_config)
    @admin_client = OryHydraClient::AdminApi.new(admin_api_client)

    public_config = OryHydraClient::Configuration.new do |config|
      config.debugging = Settings.openid.provider.debugging
      config.server_index = nil # デフォルトの0ではHydraとClientが同一ホストである設定になるため解除する
      config.host = Settings.openid.provider.public_host
      config.username = Settings.openid.client_id
      config.password = Settings.openid.password
    end
    public_api_client = OryHydraClient::ApiClient.new(public_config)
    @public_client = OryHydraClient::PublicApi.new(public_api_client)
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

  def introspect_token(token, scope = '')
    opts = {
      scope: scope || Settings.openid.scope
    }
    @admin_client.introspect_o_auth2_token(token, opts)
  end
  
  def begin_login_url
    params = {
      response_type: 'code',
      client_id: HydraService::CLIENT_ID,
      redirect_uri: HydraService::REDIRECT_URI,
      scope: Settings.openid.scope,
      state: SecureRandom.hex(20)
    }
    encoded_params = URI.encode_www_form(params)
    "#{Settings.openid.provider.auth_endpoint}?#{encoded_params}"
  end

  def issue_token(code, refresh_token = "")
    opts = {
      code: code,
      refresh_token: refresh_token,
      redirect_uri: REDIRECT_URI,
      client_id: CLIENT_ID,
      header_params: {
        Authorization: @public_client.api_client.config.basic_auth_token
      }
    }
    @public_client.oauth2_token('authorization_code', opts)
  end

  def id_token_active?(id_token)
    jwks = @public_client.well_known
    return false unless jwks.valid?

    begin
      # see. https://www.ory.sh/hydra/docs/security-architecture/#rs256
      JWT.decode(id_token, nil, true, {
        algorithms: %w[RS256],
        jwks: jwks.to_hash
      })
    rescue JWT::DecodeError => error
      return false
    end

    true
  end
  
  def begin_logout_url
    params = {
      response_type: 'code',
      client_id: HydraService::CLIENT_ID,
      redirect_uri: HydraService::REDIRECT_URI,
      scope: Settings.openid.scope,
      state: SecureRandom.hex(20)
    }
    encoded_params = URI.encode_www_form(params)
    "#{Settings.openid.provider.logout_endpoint}?#{encoded_params}"
  end

  def log_out(user)
    @admin_client.revoke_authentication_session(user.id.to_s)
  end
end
