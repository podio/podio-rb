# Retry requests with expired access tokens
#
module Podio
  module Middleware
    class OAuth2 < Faraday::Middleware
      def call(env)
        orig_env = env.dup
        begin
          @app.call(env)
        rescue TokenExpired
          Podio.client.refresh_access_token

          # new access token needs to be put into the header
          orig_env[:request_headers].merge!(Podio.client.configured_headers)

          # rewind the body if this was a file upload
          orig_env[:body].rewind if orig_env[:body].respond_to?(:rewind)

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
