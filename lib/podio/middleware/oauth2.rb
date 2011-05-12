# Retry requests with expired access tokens
#
module Podio
  module Middleware
    class OAuth2 < Faraday::Middleware
      def call(env)
        podio_client = env[:request][:client]
        orig_env = env.dup

        begin
          @app.call(env)
        rescue TokenExpired
          podio_client.refresh_access_token

          # new access token needs to be put into the header
          orig_env[:request_headers].merge!(podio_client.configured_headers)

          # redo the request with the new access token
          @app.call(orig_env)
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
