class Podio::Reminder < ActivePodio::Base
  property :reminder_id, :integer
  property :remind_delta, :integer

  alias_method :id, :reminder_id
  
  class << self
    def delete(id)
      Podio.connection.delete("/reminder/#{id}").body
    end
    
    def snooze(id)
      Podio.connection.post("/reminder/#{id}/snooze").body
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/reminder/#{id}"
        req.body = attributes
      end
      response.status
    end
  end
  
end
