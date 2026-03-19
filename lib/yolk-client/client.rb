require 'yolk-client/connection'
require 'yolk-client/request'
require 'yolk-client/authentication'

module YolkClient
  class Client

    %w(
    utils
    enrollments
    organizations
    terms
    courses
    sections
    term_accesses
    users
    ).each{|lib| require 'yolk-client/client/' + lib}

    include YolkClient::Client::Utils
    include YolkClient::Client::Enrollments
    include YolkClient::Client::Organizations
    include YolkClient::Client::Terms
    include YolkClient::Client::Courses
    include YolkClient::Client::Sections
    include YolkClient::Client::TermAccesses
    include YolkClient::Client::Users

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new Client
    def initialize(options={})
      options = YolkClient.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Connection
    include Request
    include Authentication
  end
end