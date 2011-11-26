class Podio::MeetingParticipant < Podio::Profile
  alias_method :id, :profile_id
  
  property :user_id, :integer
end
