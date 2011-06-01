require 'faraday_middleware'
require 'faraday/request/john-hancock_signature'
require 'faraday/request/multi_json'
require 'faraday/response/raise_http_4xx'
require 'faraday/response/raise_http_5xx'
require 'faraday/response/yolkify'

module Yolk
  module Connection
    private

    # Setup faraday connection and all of its middleware
    def connection(raw=false)
      options = {
        :headers => {'Accept' => "application/#{format}", 'User-Agent' => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => endpoint,
      }

      Faraday.new(options) do |builder|
        builder.use Faraday::Request::JohnHancockSignature, authentication if authenticated?
        builder.use Faraday::Request::MultiJson
        builder.use Faraday::Response::RaiseHttp4xx
        builder.use Faraday::Response::Yolkify unless raw
        unless raw
          case format.to_s.downcase
          when 'json'
            builder.use Faraday::Response::ParseJson
          when 'xml'
            builder.use Faraday::Response::ParseXml
          end
        end
        builder.use Faraday::Response::RaiseHttp5xx
#        builder.use VCR::Middleware::Faraday do |cassette|
#          cassette.name    'faraday_example'
#          cassette.options :record => :new_episodes, :match_requests_on => [:method, :uri, :headers]
#        end if defined?(VCR)
        builder.adapter(adapter)
      end
    end
  end
end