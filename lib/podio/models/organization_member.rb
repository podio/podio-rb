# Encapsulates a user's indirect membership (through spaces) of an organization.
class Podio::OrganizationMember < ActivePodio::Base
  property :spaces, :hash
  property :profile, :hash
  property :admin, :boolean

  has_one :user, :class => 'User'
  has_one :contact, :class => 'Contact', :property => :profile

  delegate :user_id, :mail, :last_active_on, :to => :user
  delegate :name, :avatar, :title, :organization, :title_and_org, :default_title, :avatar_url, :to => :contact
  
  class << self
    def find_all_for_org(org_id, options = {})
      list Podio.connection.get { |req|
        req.url("/org/#{org_id}/member/", options)
      }.body
    end

    def find(org_id, user_id)
      member Podio.connection.get("/org/#{org_id}/member/#{user_id}").body
    end
    
    def delete(org_id, user_id)
      Podio.connection.delete("/org/#{org_id}/member/#{user_id}").status
    end
    
    def make_admin(org_id, user_id)
      response = Podio.connection.post do |req|
        req.url "/org/#{org_id}/admin/"
        req.body = { :user_id => user_id.to_i }
      end
      response.status
    end

    def remove_admin(org_id, user_id)
      Podio.connection.delete("/org/#{org_id}/admin/#{user_id}").status
    end
    
  end
end
