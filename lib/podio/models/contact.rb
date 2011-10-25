class Podio::Contact < Podio::Profile
  include ActivePodio::Updatable
  
  property :user_id, :integer
  property :organization, :string
  property :role, :string # Only available when getting contacts for a space
  property :removable, :boolean # Only available when getting contacts for a space
  property :type, :string # user, space, connection - blank probably means it's a real user / Podio member
  property :link, :string
  property :last_seen_on, :datetime

  alias_method :id, :user_id

  def update
    self.class.update_contact(self.profile_id, self.attributes)
  end

end
