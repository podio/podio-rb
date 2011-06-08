# Encapsulates a user's membership of a space.
class Podio::SpaceMember < ActivePodio::Base
  property :role, :string
  property :invited_on, :datetime
  property :started_on, :datetime

  has_one :user, :class => User

  delegate :user_id, :name, :to => :user

  alias_method :id, :user_id
end
