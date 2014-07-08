# Do some debug logging
#
module Podio
  module Middleware
    class Logger < Faraday::Middleware
      def call(env)
        # Preserve request body
        env[:request_body] = env[:body] if env[:body]

        Podio.client.log(env) do
          @app.call(env)
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
