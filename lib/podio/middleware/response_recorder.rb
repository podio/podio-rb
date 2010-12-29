require 'digest/md5'

module Podio
  module Middleware
    class ResponseRecorder < Faraday::Response::Middleware
      def self.register_on_complete(env)
        env[:response].on_complete do |finished_env|
          response = "['#{Faraday::Utils.normalize_path(finished_env[:url])}', :#{finished_env[:method]}, #{finished_env[:status]}, #{finished_env[:response_headers]}, '#{finished_env[:body]}']"

          filename = Digest::MD5.hexdigest(finished_env[:url].request_uri)
          File.open("#{filename}.rack", 'w') { |f| f.write(response) }
        end
      end
    end
  end
end
