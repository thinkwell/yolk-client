require 'faraday'

module Yolk
  module Configuration
    # An array of valid keys in the options hash when configuring yolk client
    VALID_OPTIONS_KEYS = [
      :adapter,
      :consumer_key,
      :consumer_secret,
      :user_agent,
      :format,
      #:oauth_token,
      #:oauth_token_secret,
      #:proxy,
      #:search_endpoint,
      :endpoint].freeze

    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, don't set an application key
    DEFAULT_CONSUMER_KEY = nil

    # By default, don't set an application secret
    DEFAULT_CONSUMER_SECRET = nil

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = 'http://yolk.heroku.com/'.freeze

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Yolk Ruby Gem".freeze

    DEFAULT_FORMAT = :json

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      Hash[VALID_OPTIONS_KEYS.map {|key| [key, send(key)] }]
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter            = DEFAULT_ADAPTER
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.endpoint           = DEFAULT_ENDPOINT
      self.format             = DEFAULT_FORMAT
      #self.oauth_token        = DEFAULT_OAUTH_TOKEN
      #self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      #self.proxy              = DEFAULT_PROXY
      #self.search_endpoint    = DEFAULT_SEARCH_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end
  end
end