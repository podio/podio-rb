# @see https://developers.podio.com/doc/contacts
class Podio::SpaceContact < Podio::Profile
  include ActivePodio::Updatable

  property :space_id, :integer
  property :organization, :string
  property :avatar, :integer

  alias_method :id, :profile_id

  def create
    self.profile_id = self.class.create_space_contact(self.space_id, self.attributes)['profile_id']
  end

  def update
    self.class.update_contact(self.profile_id, self.attributes)
  end

  def destroy
    self.class.delete_contact(self.profile_id)
  end
end
