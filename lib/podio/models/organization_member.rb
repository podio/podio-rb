# Encapsulates a user's indirect membership (through spaces) of an organization.
class Podio::OrganizationMember < ActivePodio::Base
  property :spaces, :hash
  property :profile, :hash
  property :admin, :boolean

  has_one :user, :class => Podio::User
  has_one :contact, :class => Podio::Contact, :property => :profile

  delegate :user_id, :mail, :last_active_on, :to => :user
  delegate :name, :avatar, :title, :organization, :title_and_org, :avatar_url, :to => :contact
end
