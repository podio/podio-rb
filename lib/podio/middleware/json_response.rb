# Custom Json response until I find a way to only parse the body once in
# the OAuth2 retry case
#
module Podio
  module Middleware
    class JsonResponse < Faraday::Response::Middleware
      begin
        require 'multi_json'

        def self.register_on_complete(env)
          env[:response].on_complete do |finished_env|
            if finished_env[:body].is_a?(String) && finished_env[:status] < 500
              finished_env[:body] = parse(finished_env[:body])
            end
          end
        end
      rescue LoadError, NameError => e
        self.load_error = e
      end

      def initialize(app)
        super
        @parser = nil
      end

      def self.parse(body)
        MultiJson.decode(body)
      rescue Object => err
        raise Faraday::Error::ParsingError.new(err)
      end
    end
  end
end
