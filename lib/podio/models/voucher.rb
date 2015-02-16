class Podio::Voucher < ActivePodio::Base
  include ActivePodio::Updatable
  
  property :campaign_id, :integer
  property :voucher_id, :integer
  property :code, :string
  property :uses, :integer
  property :created_on, :datetime

  alias_method :id, :voucher_id

  def create
    result = self.class.create(self.attributes)
    self.update_attributes(result.attributes)
  end

  def update
    result = self.class.update(self.voucher_id, self.attributes)
    self.update_attributes(result.attributes)
  end

  def delete
    self.class.delete(self.voucher_id)
  end

  class << self
    def create(attributes)
      member Podio.connection.post { |req|
        req.url "/campaign/#{attributes[:campaign_id]}/voucher"
        req.body = attributes
      }.body
    end
    
    def generate(attributes)
      Podio.connection.post { |req|
        req.url "/campaign/#{attributes[:campaign_id]}/voucher/generate"
        req.body = attributes
      }.status
    end

    def update(id, attributes)
      member Podio.connection.put { |req|
        req.url "/campaign/voucher/#{id}"
        req.body = attributes
      }.body
    end

    def delete(id)
      Podio.connection.delete("/campaign/voucher/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/campaign/voucher/#{id}").body
    end

    def find_all(campaign_id, options = {})
      list Podio.connection.get { |req|
        req.url("/campaign/#{campaign_id}/voucher", options)
      }.body
    end

    def export(campaign_id, options = {})
      Podio.connection.get { |req|
        req.url("/campaign/#{campaign_id}/voucher/export", options)
      }.body
    end
  end
end
