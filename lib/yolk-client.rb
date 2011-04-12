require 'yolk-client/configuration'
require 'yolk-client/client'
require 'yolk-client/error'

module Yolk
  extend Configuration

  def self.client(options={})
    Yolk::Client.new(options)
  end
end
