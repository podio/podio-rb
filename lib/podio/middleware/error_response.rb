# Handle HTTP response status codes
#
module Podio
  module Middleware
    class ErrorResponse < Faraday::Response::Middleware
      def self.register_on_complete(env)
        env[:response].on_complete do |finished_env|
          case finished_env[:status]
            when 200, 204
              # pass
            when 400
              raise BadRequestError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            when 401
              if finished_env[:body]['error_description'] =~ /expired_token/
                raise TokenExpired.new(finished_env[:body], finished_env[:status], finished_env[:url])
              else
                raise AuthorizationError.new(finished_env[:body], finished_env[:status], finished_env[:url])
              end
            when 403
              raise AuthorizationError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            when 404
              raise NotFoundError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            when 409
              raise ConflictError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            when 410
              raise GoneError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            when 500
              raise ServerError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            when 502, 503
              raise UnavailableError.new(finished_env[:body], finished_env[:status], finished_env[:url])
            else
              # anything else is something unexpected, so raise it
              raise ServerError.new(finished_env[:body], finished_env[:status], finished_env[:url])
          end
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
