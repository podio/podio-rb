module Podio
  module Hook
    include Podio::ResponseWrapper
    extend self
    
    def create(hookable_type, hookable_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/hook/#{hookable_type}/#{hookable_id}/"
        req.body = {:url => attributes[:url], :type => attributes[:type]}
      end

      response.body['hook_id']
    end
    
    def find_all_for(hookable_type, hookable_id)
      list Podio.connection.get("/hook/#{hookable_type}/#{hookable_id}/").body
    end
  end
end