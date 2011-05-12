module Podio
  module Status
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/status/#{id}").body
    end

    def create(space_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/status/space/#{space_id}/"
        req.body = attributes
      end

      response.body['status_id']
    end
  end
end
