# Handle HTTP response status codes
#
module Podio
  module Middleware
    class ErrorResponse < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status]
          when 200, 204
            # pass
          when 400
            if env[:body]['error'] == 'invalid_grant'
              raise InvalidGrantError.new(env[:body], env[:status], env[:url])
            else
              raise BadRequestError.new(env[:body], env[:status], env[:url])
            end
          when 401
            if env[:body]['error_description'] =~ /expired_token/
              raise TokenExpired.new(env[:body], env[:status], env[:url])
            else
              raise AuthorizationError.new(env[:body], env[:status], env[:url])
            end
          when 402
            raise PaymentRequiredError.new(env[:body], env[:status], env[:url])
          when 403
            if env[:body]['error'] == 'requestable_forbidden'
              raise RequestableAuthorizationError.new(env[:body], env[:status], env[:url])
            else
              raise AuthorizationError.new(env[:body], env[:status], env[:url])
            end
          when 404
            raise NotFoundError.new(env[:body], env[:status], env[:url])
          when 409
            raise ConflictError.new(env[:body], env[:status], env[:url])
          when 410
            raise GoneError.new(env[:body], env[:status], env[:url])
          when 420
            raise RateLimitError.new(env[:body], env[:status], env[:url])
          when 500
            raise ServerError.new(env[:body], env[:status], env[:url])
          when 502, 503
            raise UnavailableError.new(env[:body], env[:status], env[:url])
          else
            # anything else is something unexpected, so raise it
            raise ServerError.new(env[:body], env[:status], env[:url])
        end
      end
    end
  end
end
