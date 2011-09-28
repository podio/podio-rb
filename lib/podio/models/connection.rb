class Podio::Connection < ActivePodio::Base
  property :connection_id, :integer
  property :type, :string
  property :name, :string
  property :last_load_on, :datetime
  property :created_on, :datetime

  property :contact_count, :integer

  alias_method :id, :connection_id

  def reload
    Connection.reload(id)
  end

  def destroy
    Connection.delete(id)
  end
  
  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/connection/'
        req.body = attributes
      end

      member response.body
    end

    def reload(id)
      Podio.connection.post("/connection/#{id}/load").body
    end

    def find(id)
      member Podio.connection.get("/connection/#{id}").body
    end

    def delete(id)
      Podio.connection.delete("/connection/#{id}").status
    end

    def all(options={})
      list Podio.connection.get('/connection/').body
    end

    def preview(id)
      Podio.connection.get("/connection/#{id}/preview").body
    end
    
  end
end
