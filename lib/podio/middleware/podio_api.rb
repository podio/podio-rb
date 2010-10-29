# Fix for Podio API specific weirdnesses
#
module Podio
  module Middleware
    class PodioApi < Faraday::Middleware
      def call(env)
        if env[:method] == :post && env[:body].nil?
          env[:body] = ''
        end

        @app.call(env)
      end

      def initialize(app)
        super
      end
    end
  end
end
