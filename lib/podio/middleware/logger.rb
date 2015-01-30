# Do some debug logging
#
module Podio
  module Middleware
    class Logger < Faraday::Middleware
      def call(env)
        # Preserve request body
        env[:request_body] = env[:body] if env[:body]

        @podio_client.log(env) do
          @app.call(env)
        end
      end

      def initialize(app, options={})
        super(app)
        @podio_client = options[:podio_client]
      end
    end
  end
end
