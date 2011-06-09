# Encapsulates a user's membership of a space.
class Podio::SpaceMember < ActivePodio::Base
  property :role, :string
  property :invited_on, :datetime
  property :started_on, :datetime

  has_one :user, :class => Podio::User

  delegate :user_id, :name, :to => :user

  alias_method :id, :user_id
  
  class << self
    def find_all_for_role(space_id, role)
      list Podio.connection.get { |req|
        req.url("/space/#{space_id}/member/#{role}/")
      }.body
    end

    def update_role(space_id, user_id, role)
      response = Podio.connection.put do |req|
        req.url "/space/#{space_id}/member/#{user_id}"
        req.body = { :role => role.to_s }
      end
      response.status
    end

    def end_membership(space_id, user_id)
      Podio.connection.delete("/space/#{space_id}/member/#{user_id}").status
    end
  end
end
