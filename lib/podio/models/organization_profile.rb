# Encapsulates an organization profile, primarily used for in app store
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

  def create
    self.class.create(self.org_id, self.attributes)
  end

  def update
    self.class.update(self.org_id, self.attributes)
  end

  def destroy
    self.class.delete(self.org_id)
  end

  handle_api_errors_for :create, :update # Call must be made after the methods to handle have been defined  

  class << self
    def find(org_id)
      member Podio.connection.get("/org/#{org_id}/appstore").body
    end

    def create(org_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/org/#{org_id}/appstore"
        req.body = attributes
      end

      response.body
    end

    def update(org_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/org/#{org_id}/appstore"
        req.body = attributes
      end
      response.status
    end

    def delete(org_id)
      Podio.connection.delete("/org/#{org_id}/appstore").status
    end
  end

end
