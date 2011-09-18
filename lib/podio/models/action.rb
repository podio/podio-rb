class Podio::Action < ActivePodio::Base
  property :action_id, :integer
  property :type, :string
  property :data, :hash
  property :text, :string

  alias_method :id, :action_id
  
  class << self
    def find(id)
      member Podio.connection.get("/action/#{id}").body
    end
  end
  
end
