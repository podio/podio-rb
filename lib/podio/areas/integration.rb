module Podio
  module Integration
    include Podio::ResponseWrapper
    extend self

    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/integration/#{app_id}"
        req.body = {:type => attributes[:type], :silent => attributes[:silent], :config => attributes[:config]}
      end

      response.body['integration_id']
    end

    def update(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/integration/#{app_id}"
        req.body = {:silent => attributes[:silent], :config => attributes[:config]}
      end

      response.body
    end

    def update_mapping(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/integration/#{app_id}/mapping"
        req.body = attributes[:mapping]
      end

      response.body
    end

    def find(app_id)
      member Podio.connection.get("/integration/#{app_id}").body
    end

    def find_available_fields_for(app_id)
      list Podio.connection.get("/integration/#{app_id}/field/").body
    end
  end
end
