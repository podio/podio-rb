module Podio
  module Space
    include Podio::ResponseWrapper
    extend self

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/space/'
        req.body = attributes
      end

      response.body
    end

    def find(id)
      member Podio.connection.get("/space/#{id}").body
    end

    def find_all_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/space/").body
    end
  end

  module SpaceInvite
    include Podio::ResponseWrapper
    extend self

    def create(space_id, role, attributes={})
      response = Podio.connection.post do |req|
        req.url "/space/#{space_id}/invite"
        req.body = attributes.merge(:role => role)
      end

      response.body
    end

    def accept(invite_code)
      response = Podio.connection.post do |req|
        req.url '/space/invite/accept'
        req.body = {:invite_code => invite_code}
      end

      response.body
    end
  end
end
