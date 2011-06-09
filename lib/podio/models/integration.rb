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
  
  has_one :created_by, :class => Podio::ByLine

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
  
  class << self
    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/integration/#{app_id}"
        req.body = {:type => attributes[:type], :silent => attributes[:silent], :config => attributes[:config]}
      end

      response.body['integration_id']
    end

    def update(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/integration/#{app_id}"
        req.body = {:silent => attributes[:silent], :config => attributes[:config]}
      end

      response.body
    end

    def update_mapping(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/integration/#{app_id}/mapping"
        req.body = attributes[:mapping]
      end
    end

    def find(app_id)
      member Podio.connection.get("/integration/#{app_id}").body
    end

    def find_available_fields_for(app_id)
      list Podio.connection.get("/integration/#{app_id}/field/").body
    end
    
    def delete(app_id)
      Podio.connection.delete("/integration/#{app_id}").status
    end

    def refresh(app_id)
      Podio.connection.post("/integration/#{app_id}/refresh").status
    end
  end
end
