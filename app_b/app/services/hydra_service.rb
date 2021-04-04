class HydraService
  include Singleton

#   def initialize
#     @config = OryHydraClient::Configuration.new do |config|
#       config.server_index = nil # デフォルトの0ではHydraとClientが同一ホストである設定になるため解除する
#       config.host = Settings.openid.provider.host
#     end
#     @client = OryHydraClient::ApiClient.new(@config)
#     @public_client = OryHydraClient::PublicApi.new(@client)
#   end

  def issue_token
    "YOU SHOULD REPLACE THIS BY ACTIVE ACCESS TOKEN"
  end
end
