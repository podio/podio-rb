module Podio
  module Middleware
    class RequestHook < Faraday::Middleware

      def call(env)
        Podio::Hooks.before_request_hooks.each { |hook|
          hook.call(env)
        }

        @app.call env
      end
    end
  end
end
