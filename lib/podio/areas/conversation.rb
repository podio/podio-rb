module Podio
  module Conversation
    include Podio::ResponseWrapper
    extend self

    def find(conversation_id)
      member Podio.connection.get("/conversation/#{conversation_id}").body
    end

    def find_all_for_reference(ref_type, ref_id)
      list Podio.connection.get("/conversation/#{ref_type}/#{ref_id}/").body
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/conversation/'
        req.body = attributes
      end
      response.body
    end

    def create_for_reference(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end
      response.body
    end
    
    def create_reply(conversation_id, text, file_ids = [])
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/reply"
        req.body = { :text => text, :file_ids => file_ids }
      end
      response.body['message_id']
    end
    
    def add_participant(conversation_id, user_id)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/participant/"
        req.body = { :user_id => user_id }
      end
      response.body
    end

  end
end
