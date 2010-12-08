module Podio
  module Item
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/item/#{id}").body
    end

    def find_all_by_external_id(app_id, external_id)
      collection Podio.connection.get("/item/app/#{app_id}/v2/?external_id=#{external_id}").body
    end
  end
end
