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

    def find_by_url(url)
      member Podio.connection.get("/org/url?url=#{url}").body
    end

    def validate_url_label(url_label)
      Podio.connection.post { |req|
        req.url '/org/url/validate'
        req.body = {:url_label => url_label}
      }.body
    end

    def find_all
      list Podio.connection.get("/org/").body
    end
    
    def get_statistics(id)
      Podio.connection.get("/org/#{id}/statistics").body
    end
    
  end
end
