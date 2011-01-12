module Podio
  module Application
    include Podio::ResponseWrapper
    extend self
    
    def find(app_id)
      member Podio.connection.get("/app/#{app_id}").body
    end
    
  end
end