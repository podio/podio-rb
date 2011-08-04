class Podio::Contact < Podio::Profile
  include ActivePodio::Updatable
  
  property :is_selected, :bool
  property :user_id, :integer
  property :organization, :string
  property :role, :string # Only available when getting contacts for a space
  property :type, :string # user, space, connection - blank probably means it's a real user / Podio member
  property :link, :string

  alias_method :id, :user_id

  def update
    self.class.update_contact(self.profile_id, self.attributes)
  end

end
