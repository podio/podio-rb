# Do some debug logging
#
module Podio
  module Middleware
    class Logger < Faraday::Middleware
      def call(env)
        env[:request][:client].log(env) do
          @app.call(env)
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
