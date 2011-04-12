require 'faraday'

module Faraday
  class Response::RaiseHttp5xx < Response::Middleware
    def on_complete(env)
      case env[:status].to_i
      when 500
        raise Yolk::InternalServerError.new(error_message(env, "Something is technically wrong."), env[:response_headers])
      when 502
        raise Yolk::BadGateway.new(error_message(env, "Yolk is down or being upgraded."), env[:response_headers])
      when 503
        raise Yolk::ServiceUnavailable.new(error_message(env, "(__-){ Yolk is over capacity."), env[:response_headers])
      end
    end

    private

    def error_message(env, body=nil)
      "#{env[:method].to_s.upcase} #{env[:url].to_s}: #{[env[:status].to_s + ':', body].compact.join(' ')}."
    end
  end
end