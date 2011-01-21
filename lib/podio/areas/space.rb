module Podio
  module Space
    include Podio::ResponseWrapper
    extend self

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/space/'
        req.body = attributes
      end

      response.body['space_id']
    end

    def find(id)
      member Podio.connection.get("/space/#{id}").body
    end

    def find_all_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/space/").body
    end
  end
end
