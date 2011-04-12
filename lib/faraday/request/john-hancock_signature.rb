require 'faraday'
require 'john-hancock'
require 'john-hancock/request_proxy/faraday'

module Faraday
  class Request::JohnHancockSignature < Faraday::Middleware
    def call(env)
      env[:request_headers]['X-Api-Key'] = @options[:consumer_key]
      JohnHancock::Signature.sign! :simple, JohnHancock::RequestProxy::FaradayRequest.new(env),
                                   {:secret => @options[:consumer_secret]}
      @app.call(env)
    end

    def initialize(app, options)
      @app, @options = app, options
    end

    private
  end
end