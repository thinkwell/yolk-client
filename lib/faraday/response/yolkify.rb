require 'faraday'

module Faraday
  class Response::Yolkify < Response::Middleware
    dependency 'yolk-client/model'

    def parse(body)
      case body
      when Hash
        ::Yolk::Model.new(body)
      when Array
        body.map { |item| item.is_a?(Hash) ? ::Yolk::Model.new(item) : item }
      else
        body
      end
    end
  end
end
