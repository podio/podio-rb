# Encapsulates a user's membership of a space.
# @see https://developers.podio.com/doc/space-members
class Podio::SpaceMember < ActivePodio::Base
  property :role, :string
  property :invited_on, :datetime
  property :started_on, :datetime
  property :ended_on, :datetime
  property :grants, :integer

  has_one :user, :class => 'User'
  has_one :contact, :class => 'Contact', :property => :profile
  has_one :space, :class => 'Space'

  delegate :user_id, :name, :to => :contact

  alias_method :id, :user_id

  class << self
    # @see https://developers.podio.com/doc/space-members/get-space-members-by-role-68043
    def find_all_for_role(space_id, role)
      list Podio.connection.get { |req|
        req.url("/space/#{space_id}/member/#{role}/")
      }.body
    end

    # @see https://developers.podio.com/doc/space-members/get-space-membership-22397
    def find_membership(space_id, user_id)
      response = Podio.connection.get { |req|
        req.url("/space/#{space_id}/member/#{user_id}/v2")
      }
      member response.body
    end

    def find_all_ended(space_id)
      list Podio.connection.get { |req|
        req.url("/space/#{space_id}/member/ended/")
      }.body
    end

    # @see https://developers.podio.com/doc/space-members/get-active-members-of-space-22395
    def find_all(space_id, options = {})
      list Podio.connection.get("/space/#{space_id}/member/", options).body
    end

    # @see https://developers.podio.com/doc/space-members/get-space-members-v2-19350328
    def find_all_for_space(space_id, options = {})
      list Podio.connection.get("/space/#{space_id}/member/v2/", options).body
    end

    # @see https://developers.podio.com/doc/space-members/update-space-memberships-22398
    def update_role(space_id, user_id, role)
      response = Podio.connection.put do |req|
        req.url "/space/#{space_id}/member/#{user_id}"
        req.body = { :role => role.to_s }
      end
      response.status
    end

    # @see https://developers.podio.com/doc/space-members/end-space-memberships-22399
    def end_membership(space_id, user_id)
      Podio.connection.delete("/space/#{space_id}/member/#{user_id}").status
    end

    # @see https://developers.podio.com/doc/space-members/get-top-users-on-space-22461
    def find_top_contacts(space_id, options = {})
      result = Podio.connection.get("/space/#{space_id}/member/top/", options).body
      %w(employee external).each do |section|
        result[section]['profiles'].map! { |profile| Contact.new(profile) } if result[section].present? && result[section]['profiles'].present?
      end
      result
    end

    def find_memberships_for_user_in_org(org_id, user_id)
      list Podio.connection.get("/org/#{org_id}/member/#{user_id}/space_member/").body
    end

    # @see https://developers.podio.com/doc/space-members/request-space-membership-6146231
    def request_membership(space_id)
      Podio.connection.post("/space/#{space_id}/member_request/").status
    end

    # @see https://developers.podio.com/doc/space-members/accept-space-membership-request-6146271
    def accept_membership_request(space_id, space_member_request_id)
      Podio.connection.post("/space/#{space_id}/member_request/#{space_member_request_id}/accept").status
    end
  end
end
