# Encapsulates a user's indirect membership (through spaces) of an organization.
# @see https://developers.podio.com/doc/organizations
class Podio::OrganizationMember < ActivePodio::Base
  property :profile, :hash
  property :admin, :boolean
  property :employee, :boolean
  property :space_memberships, :integer

  has_one :user, :class => 'User'
  has_one :contact, :class => 'Contact', :property => :profile

  delegate :user_id, :mail, :to => :user
  delegate :name, :avatar, :link, :title, :organization, :title_and_org, :default_title, :last_seen_on, :to => :contact

  class << self
    # @see https://developers.podio.com/doc/organizations/get-organization-members-50661
    def find_all_for_org(org_id, options = {})
      list Podio.connection.get { |req|
        req.url("/org/#{org_id}/member/", options)
      }.body
    end

    def search(org_id, query, options = {})
      options[:query] = query
      list Podio.connection.get { |req|
        req.url("/org/#{org_id}/member/search/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/organizations/get-organization-member-50908
    def find(org_id, user_id)
      member Podio.connection.get("/org/#{org_id}/member/#{user_id}").body
    end

    # @see https://developers.podio.com/doc/organizations/end-organization-membership-50689
    def delete(org_id, user_id)
      Podio.connection.delete("/org/#{org_id}/member/#{user_id}").status
    end

    # @see https://developers.podio.com/doc/organizations/end-organization-membership-19410652
    def leave(org_id)
      Podio.connection.post("/org/#{org_id}/leave").status
    end

    def delete_info(org_id, user_id)
      result = Podio.connection.get("/org/#{org_id}/member/#{user_id}/end_member_info").body
      %w{ to_promote to_remove to_delete }.each do |type|
        result[type].collect! { |member| self.klass_from_string('SpaceMember').new(member) } if result[type].present?
      end
      result
    end

    # @see https://developers.podio.com/doc/organizations/add-organization-admin-50854
    def make_admin(org_id, user_id)
      response = Podio.connection.post do |req|
        req.url "/org/#{org_id}/admin/"
        req.body = { :user_id => user_id.to_i }
      end
      response.status
    end

    # @see https://developers.podio.com/doc/organizations/remove-organization-admin-50855
    def remove_admin(org_id, user_id)
      Podio.connection.delete("/org/#{org_id}/admin/#{user_id}").status
    end

  end
end
