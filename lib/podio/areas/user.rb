module Podio
  module User
    include Podio::ResponseWrapper
    extend self

    def current
      member Podio.connection.get("/user/").body
    end

    def create(token, attributes)
      response = Podio.connection.post do |req|
        req.url '/user/'
        req.body = attributes.merge(:token => token)
      end

      response.body['user_id']
    end
  end
end
