module Podio
  module OAuth
    include Podio::ResponseWrapper
    extend self

    def authorize(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/authorize"
        req.body = attributes
      end

      response.body
    end
    
  end
end