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

    def find_by_url(url)
      member Podio.connection.get("/space/url?url=#{url}").body
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
  
  module SpaceMember
    include Podio::ResponseWrapper
    extend self

    def find_all_for_role(space_id, role)
      list Podio.connection.get { |req|
        req.url("/space/#{space_id}/member/#{role}/")
      }.body
    end

    def update_role(space_id, user_id, role)
      response = Podio.connection.put do |req|
        req.url "/space/#{space_id}/member/#{user_id}"
        req.body = { :role => role.to_s }
      end
      response.status
    end

    def end_membership(space_id, user_id)
      Podio.connection.delete("/space/#{space_id}/member/#{user_id}").status
    end

  end
end
