require 'yolk-client/configuration'
require 'yolk-client/client'
require 'yolk-client/error'

module Yolk
  extend Configuration

  # Alias for Yolk::Client.new
  def self.client(options={})
    Yolk::Client.new(options)
  end

  # Delegate to Yolk::Client
  def self.method_missing(method, *args, &block)
    a_client = client
    return super unless a_client.respond_to?(method)
    a_client.send(method, *args, &block)
  end

  def self.respond_to?(method, include_private = false)
    client.respond_to?(method, include_private) || super(method, include_private)
  end
end
