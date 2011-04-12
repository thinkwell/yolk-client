require 'yolk-client/connection'
require 'yolk-client/request'
require 'yolk-client/authentication'

module Yolk
  class Client

    require 'yolk-client/client/enrollments'

    include Yolk::Client::Enrollments

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new Client
    def initialize(options={})
      options = Yolk.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Connection
    include Request
    include Authentication
  end
end