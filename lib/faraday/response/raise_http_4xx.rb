require 'faraday'

module Faraday
  class Response::RaiseHttp4xx < Response::Middleware
    def on_complete(env)
      case env[:status].to_i
      when 400
        raise YolkClient::BadRequest.new(error_message(env), env[:response_headers])
      when 401
        raise YolkClient::Unauthorized.new(error_message(env), env[:response_headers])
      when 403
        raise YolkClient::Forbidden.new(error_message(env), env[:response_headers])
      when 404
        raise YolkClient::NotFound.new(error_message(env), env[:response_headers], env[:body])
      when 406
        raise YolkClient::NotAcceptable.new(error_message(env), env[:response_headers])
      when 422
        raise YolkClient::UnprocessableEntity.new(error_message(env), env[:response_headers], env[:body])
      end
    end

    private

    def error_message(env)
      "#{env[:method].to_s.upcase} #{env[:url].to_s}: #{env[:status]}#{error_body(env[:body])}"
    end

    def error_body(body)
      if body.nil?
        nil
      elsif body['error']
        ": #{body['error']}"
      elsif body['errors']
        ": #{body['errors'].inspect}"
      end
    end
  end
end
