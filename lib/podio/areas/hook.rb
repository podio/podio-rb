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
    
    def verify(hook_id)
      Podio.connection.post do |req|
        req.url "/hook/#{hook_id}/verify/request"
      end
    end
    
    def delete(hook_id)
      Podio.connection.delete do |req|
        req.url "/hook/#{hook_id}"
      end      
    end
    
    def find_all_for(hookable_type, hookable_id)
      list Podio.connection.get("/hook/#{hookable_type}/#{hookable_id}/").body
    end
  end
end