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
          @podio_client.refresh_access_token

          # new access token needs to be put into the header
          orig_env[:request_headers].merge!(@podio_client.configured_headers)

          # rewind the body if this was a file upload
          orig_env[:body].rewind if orig_env[:body].respond_to?(:rewind)

          # redo the request with the new access token
          @app.call(orig_env)
        end
      end

      def initialize(app, options={})
        super(app)
        @podio_client = options[:podio_client]
      end
    end
  end
end
