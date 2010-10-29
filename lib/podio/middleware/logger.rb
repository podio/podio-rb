# Do some debug logging
#
module Podio
  module Middleware
    class Logger < Faraday::Middleware
      def call(env)
        puts "\n==> #{env[:method].to_s.upcase} #{env[:url]} \n\n"
        @app.call(env)
      end

      def initialize(app)
        super
      end
    end
  end
end
