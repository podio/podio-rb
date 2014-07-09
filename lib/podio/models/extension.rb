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

    def find_all_for_user(user_id, options = {})
      list Podio.connection.get { |req|
        req.url("/extension/user/#{user_id}", options)
      }.body
    end

    def find(id)
      member Podio.connection.get("/extension/#{id}").body
    end

    def update(id, attributes, options={})
      response = Podio.connection.put do |req|
        req.url("/extension/#{id}", options)
        req.body = attributes
      end
      response.status
    end

    def delete(id)
      Podio.connection.delete("/extension/#{id}").body
    end

  end
end
