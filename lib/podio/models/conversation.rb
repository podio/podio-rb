# @see https://developers.podio.com/doc/conversations
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
  property :excerpt, :string
  property :last_event_on, :datetime
  property :starred, :boolean
  property :unread, :boolean
  property :type, :string

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

    # @see https://developers.podio.com/doc/conversations/create-conversation-22441
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/conversation/'
        req.body = attributes
      end
      response.body
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
    def add_participant(conversation_id, user_id)
      response = Podio.connection.post do |req|
        req.url "/conversation/#{conversation_id}/participant/"
        req.body = { :user_id => user_id }
      end
      response.body
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

  end
end
