# @see https://developers.podio.com/doc/conversations
class Podio::Conversation < ActivePodio::Base
  include ActivePodio::Updatable

  property :conversation_id, :integer
  property :subject, :string
  property :pinned, :boolean

  # When inputting conversation
  property :text, :string
  property :participants, :array
  property :file_ids, :array
  property :embed_id, :integer
  property :embed_file_id, :integer

  # When outputting conversation(s)
  property :link, :string
  property :created_on, :datetime
  property :excerpt, :string
  property :last_event_on, :datetime
  property :starred, :boolean
  property :unread, :boolean
  property :type, :string
  property :push, :hash
  property :presence, :hash

  has_one :embed, :class => 'Embed'
  has_one :embed_file, :class => 'FileAttachment'
  has_one :created_by, :class => 'ByLine'
  has_many :files, :class => 'FileAttachment'
  has_many :messages, :class => 'ConversationMessage'
  has_many :participants_full, :class => 'ConversationParticipant'

  alias_method :id, :conversation_id
  
  # So tasks can refer to ref.name on all types of references
  def name
    self.subject || self.excerpt
  end

  def save
    self[:file_ids] ||= []
    model = self.class.create(self.attributes)
    self.attributes = model.attributes
  end

  class << self
    # @see https://developers.podio.com/doc/conversations/get-conversations-34822801
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/conversation/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/conversations/get-flagged-conversations-35466860
    def find_all_by_flag(flag, options={})
      list Podio.connection.get { |req|
        req.url("/conversation/#{flag}/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/conversations/get-conversation-22369
    def find(conversation_id)
      member Podio.connection.get("/conversation/#{conversation_id}").body
    end

    # @see https://developers.podio.com/doc/conversations/get-conversations-on-object-22443
    def find_all_for_reference(ref_type, ref_id)
      list Podio.connection.get("/conversation/#{ref_type}/#{ref_id}/").body
    end

    # @see https://developers.podio.com/doc/conversations/create-conversation-v2-37301474
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/conversation/v2/'
        req.body = attributes
      end
      member response.body
    end

    # @see https://developers.podio.com/doc/conversations/create-conversation-on-object-22442
    def create_for_reference(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end
      response.body
    end

    # @see https://developers.podio.com/doc/conversations/reply-to-conversation-22444
    def create_reply(conversation_id, text, file_ids=[], embed_id=nil, embed_file_id=nil)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/reply"
        req.body = {:text => text, :file_ids => file_ids, :embed_id => embed_id, :embed_file_id => embed_file_id}
      end
      response.body['message_id']
    end

    # @see https://developers.podio.com/doc/conversations/add-participants-384261
    def add_participants(conversation_id, participants)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/participant/"
        req.body = { :participants => participants }
      end
      response.body
    end

    def add_participant(conversation_id, user_id)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/participant/"
        req.body = { :user_id => user_id }
      end
      response.body
    end

    # @see https://developers.podio.com/doc/conversations/mark-all-conversations-as-read-38080233
    def mark_all_as_read
      Podio.connection.post("/conversation/read").status
    end

    # @see https://developers.podio.com/doc/conversations/mark-conversation-as-read-35441525
    def mark_as_read(conversation_id)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/read"
      end
      response.status
    end

    # @see https://developers.podio.com/doc/conversations/mark-conversation-as-unread-35441542
    def mark_as_unread(conversation_id)
      Podio.connection.delete("/conversation/#{conversation_id}/read").status
    end

    # @see https://developers.podio.com/doc/conversations/star-conversation-35106944
    def star(conversation_id)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/star"
      end
      response.status
    end

    # @see https://developers.podio.com/doc/conversations/unstar-conversation-35106990
    def unstar(conversation_id)
      Podio.connection.delete("/conversation/#{conversation_id}/star").status
    end

    def get_omega_auth_tokens
      response = Podio.connection.post do |req|
        req.url '/conversation/omega/access_token'
      end
      response.body
    end

    # @see https://developers.podio.com/doc/conversations/get-flagged-conversation-counts-35467925
    def unread_count
      Podio.connection.get("/conversation/unread/count").body['value']
    end

    # @see https://developers.podio.com/doc/conversations/get-flagged-conversation-counts-35467925
    def starred_count
      Podio.connection.get("/conversation/starred/count").body['value']
    end

    # @see https://developers.podio.com/doc/conversations/leave-conversation-35483748
    def leave(conversation_id)
      Podio.connection.post("/conversation/#{conversation_id}/leave")
    end

  end
end
