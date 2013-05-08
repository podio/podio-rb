# Encapsulates an organization profile, primarily used for in app store
# @see https://developers.podio.com/doc/organizations
class Podio::OrganizationProfile < ActivePodio::Base
  include ActivePodio::Updatable

  property :org_id, :integer
  property :avatar, :integer
  property :image, :hash
  property :name, :string
  property :mail, :array
  property :phone, :array
  property :url, :array
  property :address, :array
  property :city, :string
  property :country, :string
  property :about, :string

  alias_method :id, :org_id
  alias_method :logo, :avatar
  alias_method :logo=, :avatar=

  # @see https://developers.podio.com/doc/organizations/create-organization-app-store-profile-87819
  def create
    self.class.create(self.org_id, self.attributes)
  end

  # @see https://developers.podio.com/doc/organizations/update-organization-app-store-profile-87805
  def update
    self.class.update(self.org_id, self.attributes)
  end

  # @see https://developers.podio.com/doc/organizations/delete-organization-app-store-profile-87808
  def destroy
    self.class.delete(self.org_id)
  end

  class << self
    # @see https://developers.podio.com/doc/organizations/get-organization-app-store-profile-87799
    def find(org_id)
      member Podio.connection.get("/org/#{org_id}/appstore").body
    end

    def find_by_url(url_label)
      member Podio.connection.get("/app_store/org/#{url_label}/profile").body
    end

    # @see https://developers.podio.com/doc/organizations/create-organization-app-store-profile-87819
    def create(org_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/org/#{org_id}/appstore"
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/organizations/update-organization-app-store-profile-87805
    def update(org_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/org/#{org_id}/appstore"
        req.body = attributes
      end
      response.status
    end

    # @see https://developers.podio.com/doc/organizations/delete-organization-app-store-profile-87808
    def delete(org_id)
      Podio.connection.delete("/org/#{org_id}/appstore").status
    end
  end

end
