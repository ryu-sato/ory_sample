class HydraService
  include Singleton

  CLIENT_ID = Settings.openid.client_id
  REDIRECT_URI = Settings.openid.redirect_uri

  def initialize
    @config = OryHydraClient::Configuration.new do |config|
      config.debugging = Settings.openid.provider.debugging
      config.server_index = nil # デフォルトの0ではHydraとClientが同一ホストである設定になるため解除する
      config.host = Settings.openid.provider.public_host
      config.username = Settings.openid.client_id
      config.password = Settings.openid.password
    end
    @client = OryHydraClient::ApiClient.new(@config)
    @public_client = OryHydraClient::PublicApi.new(@client)
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
        Authorization: @config.basic_auth_token
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
end
