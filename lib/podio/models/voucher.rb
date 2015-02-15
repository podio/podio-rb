class Podio::Voucher < ActivePodio::Base
  property :campaign_id, :integer
  property :voucher_id, :integer
  property :code, :string
  property :uses, :integer
  property :created_on, :datetime

  alias_method :id, :voucher_id

  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/campaign/#{self.campaign_id}/voucher"
        req.body = attributes
      end

      response.status
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/campaign/voucher/#{id}"
        req.body = attributes
      end

      response.status
    end

    def delete(id)
      Podio.connection.delete("/campaign/voucher/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/campaign/voucher/#{id}").body
    end

    def find_all(campaign_id, options = {})
      collection Podio.connection.get { |req|
        req.url("/campaign/#{campaign_id}/voucher", options)
      }.body
    end
  end
end
