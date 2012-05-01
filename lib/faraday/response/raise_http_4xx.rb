require 'faraday'

module Faraday
  class Response::RaiseHttp4xx < Response::Middleware
    def on_complete(env)
      case env[:status].to_i
      when 400
        raise Yolk::BadRequest.new(error_message(env), env[:response_headers])
      when 401
        raise Yolk::Unauthorized.new(error_message(env), env[:response_headers])
      when 403
        raise Yolk::Forbidden.new(error_message(env), env[:response_headers])
      when 404
        raise Yolk::NotFound.new(error_message(env), env[:response_headers], env[:body])
      when 406
        raise Yolk::NotAcceptable.new(error_message(env), env[:response_headers])
      when 422
        raise Yolk::UnprocessableEntity.new(error_message(env), env[:response_headers], env[:body])
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
