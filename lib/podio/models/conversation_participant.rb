# @see https://developers.podio.com/doc/conversations
class Podio::ConversationParticipant < ActivePodio::Base
  property :created_on, :datetime

  has_one :user, :class => 'User'
  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  delegate :id, :name, :avatar, :link, :to => :user, :prefix => false
end
