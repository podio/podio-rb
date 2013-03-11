# @see https://developers.podio.com/doc/conversations
class Podio::ConversationEvent < ActivePodio::Base
  property :event_id, :integer
  property :action, :string # message, participant_add, participant_leave
  property :created_on, :datetime

  has_one :data, :class_property => :action, :class_map => { :message => 'ConversationMessage', :participant_leave => 'User', :participant_add => 'User' }
  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  alias_method :id, :event_id

  class << self
    # @see https://developers.podio.com/doc/conversations/get-conversation-events-35440697
    def find_all(conversation_id, options = {})
      list Podio.connection.get { |req|
        req.url("/conversation/#{conversation_id}/event/", options)
      }.body
    end

    def add_participants(conversation_id, participants)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/participant/v2/"
        req.body = { :participants => participants }
      end
      list response.body
    end

    def create_reply(conversation_id, text, file_ids=[], embed_id=nil, embed_file_id=nil)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/reply/v2"
        req.body = {:text => text, :file_ids => file_ids, :embed_id => embed_id, :embed_file_id => embed_file_id}
      end
      member response.body
    end

    # @see https://developers.podio.com/doc/conversations/get-conversation-event-35628220
    def find(id)
      member Podio.connection.get("/conversation/event/#{id}").body
    end
  end

end
