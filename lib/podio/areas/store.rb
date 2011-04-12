module Podio
  module StoreShare
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/app_store/#{id}/v2").body
    end

    def find_all_private_for_org(org_id)
      list Podio.connection.get("/app_store/org/#{org_id}/").body['shares']
    end

  end

end
