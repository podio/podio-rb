# Retry requests with expired access tokens
#
module Podio
  module Middleware
    class OAuth2 < Faraday::Middleware
      def call(env)
        podio_client = env[:request][:client]

        begin
          @app.call(env)
        rescue Error::TokenExpired
          podio_client.refresh_access_token

          params = env[:url].query_values || {}
          env[:url].query_values = params.merge('oauth_token' => podio_client.oauth_token.access_token)

          # redo the request with the new access token
          @app.call(env)
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
