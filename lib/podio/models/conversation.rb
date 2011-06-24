class Podio::Conversation < ActivePodio::Base
  property :conversation_id, :integer
  property :subject, :string

  # When inputting conversation
  property :text, :string
  property :participants, :array
  property :file_ids, :array
  property :embed_id, :integer
  property :embed_file_id, :integer
  
  # When outputting conversation(s)
  property :created_on, :datetime
  has_one :embed, :class => 'Embed'
  has_one :embed_file, :class => 'FileAttachment'
  has_one :created_by, :class => 'ByLine'
  has_many :files, :class => 'FileAttachment'
  has_many :messages, :class => 'ConversationMessage'
  has_many :participants_full, :class => 'ConversationParticipant'

  
  alias_method :id, :conversation_id
  alias_method :name, :subject # So tasks can refer to ref.name on all types of references

  def save
    self[:file_ids] ||= []
    response = Conversation.create(self.attributes)
    self.conversation_id = response['conversation_id']
  end
  
  handle_api_errors_for :save # Call must be made after the methods to handle have been defined
  
  class << self
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
