# Do some debug logging
#
module Podio
  module Middleware
    class Logger < Faraday::Middleware
      def call(env)
        if env[:request][:client].debug
          puts "\n==> #{env[:method].to_s.upcase} #{env[:url]} \n\n"
        end

        begin
          @app.call(env)
        ensure
          if env[:request][:client].debug
            puts "\n== (#{env[:status]}) ==> #{env[:body]}\n\n"
          end
        end
      end

      def initialize(app)
        super
      end
    end
  end
end
