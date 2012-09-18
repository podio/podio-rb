# https://developers.podio.com/doc/connections
class Podio::Connection < ActivePodio::Base
  property :connection_id, :integer
  property :type, :string
  property :name, :string
  property :last_load_on, :datetime
  property :created_on, :datetime

  property :contact_count, :integer

  alias_method :id, :connection_id

  # https://developers.podio.com/doc/connections/load-contacts-from-connection-59199
  def reload
    Connection.reload(id)
  end

  # https://developers.podio.com/doc/connections/delete-connection-59186
  def destroy
    Connection.delete(id)
  end

  class << self
    # https://developers.podio.com/doc/connections/create-connection-60821
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/connection/'
        req.body = attributes
      end

      member response.body
    end

    # https://developers.podio.com/doc/connections/load-contacts-from-connection-59199
    def reload(id)
      Podio.connection.post("/connection/#{id}/load").body
    end

    # https://developers.podio.com/doc/connections/get-connection-59150
    def find(id)
      member Podio.connection.get("/connection/#{id}").body
    end

    # https://developers.podio.com/doc/connections/delete-connection-59186
    def delete(id)
      Podio.connection.delete("/connection/#{id}").status
    end

    # https://developers.podio.com/doc/connections/get-connections-59164
    def all(options={})
      list Podio.connection.get('/connection/').body
    end

    def preview(id, options={})
      Podio.connection.get { |req|
        req.url("/connection/#{id}/preview", options)
      }.body
    end

  end
end
