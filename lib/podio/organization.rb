module Podio
  module Organization
    include Podio::ResponseWrapper
    extend self

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/org/#{id}"
        req.body = attributes
      end

      response.status
    end

    def delete(id)
      Podio.connection.delete("/org/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/org/#{id}").body
    end
    
    def find_all
      list Podio.connection.get("/org/").body
    end
    
  end
end
