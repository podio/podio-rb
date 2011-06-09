class Podio::Conversation < ActivePodio::Base
  property :conversation_id, :integer
  property :subject, :string
  
  # When inputting conversation
  property :text, :string
  property :participants, :array
  property :file_ids, :array

  # When outputting conversation(s)
  property :created_on, :datetime
  has_one :created_by, :class => Podio::ByLine
  has_many :files, :class => Podio::FileAttachment
  has_many :messages, :class => Podio::ConversationMessage
  has_many :participants_full, :class => Podio::ConversationParticipant
  
  alias_method :id, :conversation_id
  alias_method :name, :subject # So tasks can refer to ref.name on all types of references

  def save
    self[:file_ids] ||= []
    response = Conversation.create(self.attributes)
    self.conversation_id = response['conversation_id']
  end
  
  handle_api_errors_for :save # Call must be made after the methods to handle have been defined
end
