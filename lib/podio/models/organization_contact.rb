# Encapsulates a primary contact for an organization, primarily used for billing purposes
# @see https://developers.podio.com/doc/contacts
class Podio::OrganizationContact < Podio::Profile
  include ActivePodio::Updatable

  property :org_id, :integer
  property :attention, :string # The name of the primary organization contact

  alias_method :id, :org_id

  def save
    Organization.update_billing_profile(id, self.attributes)
  end

end
