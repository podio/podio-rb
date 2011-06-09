class Podio::ConversationMessage < ActivePodio::Base
  property :message_id, :integer
  property :text, :string
  property :created_on, :datetime

  has_one :created_by, :class => Podio::ByLine
  has_many :files, :class => Podio::FileAttachment
  
  alias_method :id, :message_id
end
