module Podio
  module Connection
    include Podio::ResponseWrapper
    extend self

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/connection/'
        req.body = attributes
      end

      response.body['connection_id']
    end

    def reload(id)
      Podio.connection.post("/connection/#{id}/load").body
    end

    def find(id)
      member Podio.connection.get("/connection/#{id}").body
    end

    def delete(id)
      Podio.connection.delete("/connection/#{id}").status
    end

    def all(options={})
      list Podio.connection.get('/connection/').body
    end
  end
end
