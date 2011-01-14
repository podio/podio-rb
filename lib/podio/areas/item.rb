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
    
    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/item/app/#{app_id}/"
        req.body = attributes
      end

      response.body['item_id']
    end    
  end
end
