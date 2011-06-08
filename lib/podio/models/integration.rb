class Podio::Integration < ActivePodio::Base
  include ActivePodio::Updatable

  property :integration_id, :integer
  property :app_id, :integer
  property :status, :string
  property :type, :string
  property :silent, :boolean
  property :config, :hash
  property :mapping, :hash
  property :updating, :boolean
  property :last_updated_on, :datetime
  property :created_on, :datetime
  
  has_one :created_by, :class => ByLine

  alias_method :id, :integration_id

  def create
    self.integration_id = Integration.create(self.app_id, attributes)
  end

  def update
    Integration.update(self.app_id, attributes)
  end

  def update_mapping
    Integration.update_mapping(self.app_id, attributes)
  end
  
  def destroy
    Integration.delete(self.app_id)
  end

  def refresh
    Integration.refresh(self.app_id)
  end
  
  handle_api_errors_for :create, :update, :update_mapping
end
