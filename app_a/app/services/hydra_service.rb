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
end
