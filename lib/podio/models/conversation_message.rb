# @see https://developers.podio.com/doc/conversations
class Podio::ConversationMessage < ActivePodio::Base
  property :message_id, :integer
  property :embed_id, :integer
  property :embed_file_id, :integer
  property :text, :string
  property :created_on, :datetime

  has_one :embed, :class => 'Embed'
  has_one :embed_file, :class => 'FileAttachment'
  has_one :created_by, :class => 'ByLine'
  has_many :files, :class => 'FileAttachment'

  alias_method :id, :message_id
end
