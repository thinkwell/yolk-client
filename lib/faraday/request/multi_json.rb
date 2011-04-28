module Faraday
  class Request::MultiJson < Request::UrlEncoded
    dependency 'multi_json'

    self.mime_type = 'application/json'.freeze

    def call(env)
      match_content_type(env) do |data|
        env[:body] = ::MultiJson.encode data
      end
      @app.call env
    end
  end
end
