class Podio::Live < ActivePodio::Base
  property :status, :string
  property :presence, :hash
  property :provider, :string
  property :push, :hash
  property :live_id, :integer
  property :settings, :hash
  property :ref, :hash

  class << self

    # @see https://hoist.podio.com/api/item/45673217
    def create(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/live/#{ref_type}/#{ref_id}"
        req.body = attributes
      end

      member response.body
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/live/#{id}/settings"
        req.body = attributes
      end
      response.status
    end

    def delete(id)
      Podio.connection.delete("/live/#{id}").body
    end

    def accept(id)
      Podio.connection.post("/live/#{id}/accept").status
    end

    def decline(id)
      Podio.connection.post("/live/#{id}/decline").status
    end

    def authorize(attributes)
      response = Podio.connection.post do |req|
        req.url "/live/omega/authorize"
        req.body = attributes
      end

      response.body
    end

    def authorize_all
      Podio.connection.post("/live/omega/authorize/all").body
    end

    def get_servers
      Podio.connection.get("/live/servers").body
    end

  end

end