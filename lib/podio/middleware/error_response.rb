# Handle HTTP response status codes
#
module Podio
  module Middleware
    class ErrorResponse < Faraday::Response::Middleware
      def self.register_on_complete(env)
        env[:response].on_complete do |finished_env|
          case finished_env[:status]
            when 400
              raise Error::BadRequestError, finished_env[:body]
            when 401
              if finished_env[:body]['error_description'] =~ /expired_token/
                raise Error::TokenExpired, finished_env[:body].inspect
              else
                raise Error::AuthorizationError, finished_env[:body].inspect
              end
            when 403
              raise Error::AuthorizationError, finished_env[:body].inspect
            when 404
              raise Error::NotFoundError, "#{finished_env[:method].to_s.upcase} #{finished_env[:url]}"
            when 410
              raise Error::GoneError, "#{finished_env[:method].to_s.upcase} #{finished_env[:url]}"
            when 500
              raise Error::ServerError, finished_env[:body].inspect
            when 502, 503
              raise Error::Unavailable, finished_env[:body].inspect
          end
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
