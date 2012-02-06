class Podio::MeetingParticipant < ActivePodio::Base
  property :status, :string

  has_one :profile, :class => 'Contact'

  delegate :name, :to => :profile

  def id
    self.profile.try(:profile_id)
  end
end
