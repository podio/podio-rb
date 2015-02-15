class Podio::Campaign < ActivePodio::Base
  property :campaign_id, :integer
  property :name, :string
  property :description, :string
  property :status, :string
  property :tier, :string
  property :rebate_type, :string
  property :rebate_config, :hash
  property :duration_type, :string
  property :duration_config, :hash

  alias_method :id, :campaign_id

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

    def find(id)
      member Podio.connection.get("/campaign/#{id}").body
    end

    def find_all(options = {})
      collection Podio.connection.get { |req|
        req.url("/campaign/", options)
      }.body
    end
  end
end
