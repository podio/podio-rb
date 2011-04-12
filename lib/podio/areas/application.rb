module Podio
  module Application
    include Podio::ResponseWrapper
    extend self
    
    def find(app_id)
      member Podio.connection.get("/app/#{app_id}").body
    end
    
    def find_all(options={})
      options.assert_valid_keys(:external_id, :space_ids, :owner_id, :status, :type)

      list Podio.connection.get { |req|
        req.url("/app/", options)
      }.body
    end

    def find_all_for_space(space_id, options = {})
      list Podio.connection.get { |req|
        req.url("/app/space/#{space_id}/", options)
      }.body
    end

    def update_order(space_id, app_ids = [])
      response = Podio.connection.put do |req|
        req.url "/app/space/#{space_id}/order"
        req.body = app_ids
      end

      response.body
    end
    
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app/"
        req.body = attributes
      end
      response.body['app_id']
    end
    
    def deactivate(id)
      Podio.connection.post("/app/#{id}/deactivate").body
    end
    
    def delete(id)
      Podio.connection.delete("/app/#{id}").body
    end    
    
  end
end