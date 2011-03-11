module Podio
  module OrganizationProfile
    include Podio::ResponseWrapper
    extend self

    def find(org_id)
      member Podio.connection.get("/org/#{org_id}/appstore").body
    end

    def create(org_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/org/#{org_id}/appstore"
        req.body = attributes
      end

      response.body
    end

    def update(org_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/org/#{org_id}/appstore"
        req.body = attributes
      end
      response.status
    end

    def delete(org_id)
      Podio.connection.delete("/org/#{org_id}/appstore").status
    end
    
  end
end