class Podio::Campaign < ActivePodio::Base
  include ActivePodio::Updatable
  
  property :campaign_id, :integer
  property :name, :string
  property :description, :string
  property :status, :string
  property :tier, :string
  property :rebate_type, :string
  property :rebate_config, :hash
  property :duration_type, :string
  property :duration_config, :hash
  property :usages, :integer

  alias_method :id, :campaign_id

  def create
    result = self.class.create(self.attributes)
    self.update_attributes(result.attributes)
  end

  def update
    result = self.class.update(self.campaign_id, self.attributes)
    self.update_attributes(result.attributes)
  end

  def activate
    self.class.activate(self.campaign_id)
  end

  def deactivate
    self.class.deactivate(self.campaign_id)
  end

  def delete
    self.class.delete(self.campaign_id)
  end

  def active?
    self.status == 'active'
  end

  def inactive?
    self.status == 'inactive'
  end

  class << self
    def create(attributes)
      member Podio.connection.post { |req|
        req.url "/campaign/"
        req.body = attributes
      }.body
    end

    def update(id, attributes)
      member Podio.connection.put { |req|
        req.url "/campaign/#{id}"
        req.body = attributes
      }.body
    end

    def delete(id)
      Podio.connection.delete("/campaign/#{id}").status
    end

    def activate(id)
      Podio.connection.post("/campaign/#{id}/activate").status
    end

    def deactivate(id)
      Podio.connection.post("/campaign/#{id}/deactivate").status
    end

    def find(id)
      member Podio.connection.get("/campaign/#{id}").body
    end

    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url("/campaign/", options)
      }.body
    end

    def find_usage(id)
      Podio.connection.get("/campaign/#{id}/usage").body
    end
  end
end
