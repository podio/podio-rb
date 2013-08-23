# @see https://developers.podio.com/doc/contacts
class Podio::Contact < Podio::Profile
  include ActivePodio::Updatable

  property :user_id, :integer
  property :organization, :string
  property :type, :string # user, space, connection - blank probably means it's a real user / Podio member
  property :space_id, :integer
  property :link, :string
  property :last_seen_on, :datetime
  property :rights, :array

  # Only available for external contacts
  property :external_id, :string
  property :external_picture, :string

  alias_method :id, :user_id

  def update
    self.class.update_contact(self.profile_id, self.attributes)
  end

  class << self
    def find_external(linked_acc_id, external_contact_id)
      member Podio.connection.post { |req|
        req.url "/contact/linked_account/#{linked_acc_id}"
        req.body = { :external_contact_id => external_contact_id }
      }.body
    end
  end

end
