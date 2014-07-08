class Podio::Extension < ActivePodio::Base
  property :name, :string
  property :installation_url, :string

  class << self
    def create(attributes, options={})
      response = Podio.connection.post do |req|
        req.url("/extension/", options)
        req.body = attributes
      end

      response.body
    end

    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url("/extension/", options)
      }.body
    end

    def find(id)
      member Podio.connection.get("/extension/#{id}").body
    end

  end
end
