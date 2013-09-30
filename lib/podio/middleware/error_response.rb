# Handle HTTP response status codes
#
module Podio
  module Middleware
    class ErrorResponse < Faraday::Response::Middleware
      def on_complete(env)
        error_class = case env[:status]
          when 200, 204
            # pass
          when 400
            case env[:body]['error']
            when 'invalid_grant'
              InvalidGrantError
            when 'rate_limit.remote'
              RemoteRateLimitError
            else
              BadRequestError
            end
          when 401
            if env[:body]['error'] =~ /expired_token/
              TokenExpired
            else
              AuthorizationError
            end
          when 402
            PaymentRequiredError
          when 403
            if env[:body]['error'] == 'requestable_forbidden'
              RequestableAuthorizationError
            else
              AuthorizationError
            end
          when 404
            NotFoundError
          when 409
            ConflictError
          when 410
            GoneError
          when 420
            RateLimitError
          when 500
            ServerError
          when 502, 503
            UnavailableError
          else
            # anything else is something unexpected, so it
            ServerError
        end

        if error_class
          raise error_class.new(env[:body], env[:status], env[:url])
        end
      end
    end
  end
end
