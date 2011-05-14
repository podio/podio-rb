# Custom Json response until I find a way to only parse the body once in
# the OAuth2 retry case
#
module Podio
  module Middleware
    class JsonResponse < Faraday::Response::Middleware
      require 'multi_json'

      def on_complete(env)
        if env[:body].is_a?(String) && is_json?(env) && env[:status] < 500
          env[:body] = parse(env[:body])
        end
      end

      def is_json?(env)
        env[:response_headers]['content-type'] =~ /application\/json/
      end

      def parse(body)
        return nil if body !~ /\S/ # json gem doesn't like decoding blank strings
        MultiJson.decode(body)
      rescue Object => err
        raise Faraday::Error::ParsingError.new(err)
      end
    end
  end
end
