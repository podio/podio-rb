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
    
  end
end