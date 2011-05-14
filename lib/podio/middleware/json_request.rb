module Podio
  module Middleware
    class JsonRequest < Faraday::Middleware
      require 'multi_json'

      def call(env)
        env[:request_headers]['Content-Type'] = 'application/json'

        if env[:body] && !env[:body].respond_to?(:to_str)
          env[:body] = MultiJson.encode(env[:body])
        end

        @app.call env
      end
    end
  end
end
