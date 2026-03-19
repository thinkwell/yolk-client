require 'yolk-client/configuration'
require 'yolk-client/client'
require 'yolk-client/mock_client'
require 'yolk-client/error'

module YolkClient
  extend Configuration

  # Alias for YolkClient::Client.new
  def self.client(options={})
    YolkClient::Client.new(options)
  end

  def self.mock_client(options={})
    YolkClient::MockClient.new(options)
  end

  # Delegate to YolkClient::Client
  def self.method_missing(method, *args, &block)
    a_client = client
    return super unless a_client.respond_to?(method)
    a_client.send(method, *args, &block)
  end

  def self.respond_to?(method, include_private = false)
    client.respond_to?(method, include_private) || super(method, include_private)
  end
end
