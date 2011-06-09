class Podio::OAuthClient < ActivePodio::Base
  include ActivePodio::Updatable

  property :auth_client_id, :integer
  property :name, :string
  property :key, :string
  property :secret, :string
  property :url, :string
  property :domain, :string

  alias_method :id, :auth_client_id

  def create
    self.auth_client_id = self.class.create(attributes)
  end

  def update
    self.class.update(self.auth_client_id, attributes)
  end

  handle_api_errors_for :create, :update # Call must be made after the methods to handle have been defined
end
