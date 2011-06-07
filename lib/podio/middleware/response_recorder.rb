require 'digest/md5'

module Podio
  module Middleware
    class ResponseRecorder < Faraday::Response::Middleware
      def on_complete(env)
        response = "['#{Faraday::Utils.normalize_path(env[:url])}', :#{env[:method]}, #{env[:status]}, #{env[:response_headers]}, '#{env[:body]}']"

        filename = Digest::MD5.hexdigest(env[:url].request_uri)
        ::File.open("#{filename}.rack", 'w') { |f| f.write(response) }
      end
    end
  end
end
