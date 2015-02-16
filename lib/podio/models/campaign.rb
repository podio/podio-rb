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
  property :usage, :integer

  alias_method :id, :campaign_id

  def create
    result = self.class.create(self.attributes)
    self.attributes[:campaign_id] = result['campaign_id']
  end

  def update
    self.class.update(self.promotion_id, self.attributes)
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
      response = Podio.connection.post do |req|
        req.url "/campaign/"
        req.body = attributes
      end

      response.status
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/campaign/#{id}"
        req.body = attributes
      end

      response.status
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
  end
end
