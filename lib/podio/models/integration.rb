# @see https://developers.podio.com/doc/integrations
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

  has_one :created_by, :class => 'ByLine'

  alias_method :id, :integration_id

  # @see https://developers.podio.com/doc/integrations/create-integration-86839
  def create
    self.integration_id = Integration.create(self.app_id, attributes)
  end

  # @see https://developers.podio.com/doc/integrations/update-integration-86843
  def update
    Integration.update(self.app_id, attributes)
  end

  # @see https://developers.podio.com/doc/integrations/update-integration-mapping-86865
  def update_mapping
    Integration.update_mapping(self.app_id, attributes)
  end

  # @see https://developers.podio.com/doc/integrations/delete-integration-86876
  def destroy
    Integration.delete(self.app_id)
  end

  # @see https://developers.podio.com/doc/integrations/refresh-integration-86987
  def refresh
    Integration.refresh(self.app_id)
  end

  class << self
    # @see https://developers.podio.com/doc/integrations/create-integration-86839
    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/integration/#{app_id}"
        req.body = {:type => attributes[:type], :silent => attributes[:silent], :config => attributes[:config]}
      end

      response.body['integration_id']
    end

    # @see https://developers.podio.com/doc/integrations/update-integration-86843
    def update(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/integration/#{app_id}"
        req.body = {:silent => attributes[:silent], :config => attributes[:config]}
      end

      response.body
    end

    # @see https://developers.podio.com/doc/integrations/update-integration-mapping-86865
    def update_mapping(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/integration/#{app_id}/mapping"
        req.body = attributes[:mapping]
      end
    end

    # @see https://developers.podio.com/doc/integrations/get-integration-86821
    def find(app_id)
      member Podio.connection.get("/integration/#{app_id}").body
    end

    # @see https://developers.podio.com/doc/integrations/get-available-fields-86890
    def find_available_fields_for(app_id)
      list Podio.connection.get("/integration/#{app_id}/field/").body
    end

    # @see https://developers.podio.com/doc/integrations/delete-integration-86876
    def delete(app_id)
      Podio.connection.delete("/integration/#{app_id}").status
    end

    # @see https://developers.podio.com/doc/integrations/refresh-integration-86987
    def refresh(app_id)
      Podio.connection.post("/integration/#{app_id}/refresh").status
    end
  end
end
