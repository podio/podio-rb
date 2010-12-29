module Podio
  module Space
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/space/#{id}").body
    end

    def find_all_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/space/").body
    end
  end
end
