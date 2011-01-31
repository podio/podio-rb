module Podio
  module User
    include Podio::ResponseWrapper
    extend self

    def current
      member Podio.connection.get("/user/").body
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/user/'
        req.body = attributes
      end

      response.body['user_id']
    end
  end
end
