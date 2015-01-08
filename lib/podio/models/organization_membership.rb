class Podio::OrganizationMembership < ActivePodio::Base
  property :employee, :boolean
  property :tier, :string
  property :space_memberships, :integer

  has_one :org, :class => 'Organization'

  class << self
    def find_all_for_user(user_id, options = {})
      list Podio.connection.get { |req|
        req.url("/org/user/#{user_id}/membership/", options)
      }.body
    end
  end
end
