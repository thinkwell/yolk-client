require 'faraday'

module Faraday
  class Response::Yolkify < Response::Middleware
    dependency 'yolk-client/model'

    def parse(body)
      case body
      when Hash
        ::YolkClient::Model.new(body)
      when Array
        body.map { |item| item.is_a?(Hash) ? ::YolkClient::Model.new(item) : item }
      else
        body
      end
    end
  end
end
