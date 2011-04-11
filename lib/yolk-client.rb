require 'yolk-client/configuration'
require 'yolk-client/client'

module Yolk
  extend Configuration

  def self.client(options={})
    Yolk::Client.new(options)
  end
end
