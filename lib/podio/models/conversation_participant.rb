class Podio::ConversationParticipant < ActivePodio::Base
  property :created_on, :datetime
  
  has_one :user, :class => Podio::User
  has_one :created_by, :class => Podio::ByLine
  has_one :created_via, :class => Podio::Via

  delegate :id, :name, :avatar, :link, :to => :user, :prefix => false
end