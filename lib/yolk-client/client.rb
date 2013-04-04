require 'yolk-client/connection'
require 'yolk-client/request'
require 'yolk-client/authentication'

module Yolk
  class Client

    %w(
    utils
    enrollments
    organizations
    terms
    courses
    ).each{|lib| require 'yolk-client/client/' + lib}

    include Yolk::Client::Utils
    include Yolk::Client::Enrollments
    include Yolk::Client::Organizations
    include Yolk::Client::Terms
    include Yolk::Client::Courses

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