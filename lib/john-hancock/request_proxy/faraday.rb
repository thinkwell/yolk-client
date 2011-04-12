require 'john-hancock'
require 'hashie'
require 'active_support/core_ext/module/delegation'

module JohnHancock::RequestProxy
  class FaradayRequest < JohnHancock::RequestProxy::Base

    delegate :scheme, :host, :port, :path, :to => :url

    def query_parameters; url.query_values; end
    def post_parameters; {}; end
    def headers; request[:request_headers]; end
    def set_header key, val
      request[:request_headers][key] = val.to_s
    end

    private

    def url; request[:url]; end
  end
end