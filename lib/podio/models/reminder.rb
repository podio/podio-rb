class Podio::Reminder < ActivePodio::Base
  property :reminder_id, :integer
  property :remind_delta, :integer

  alias_method :id, :reminder_id
  
  class << self
    def delete(ref_type, ref_id)
      Podio.connection.delete("/reminder/#{ref_type}/#{ref_id}").body
    end
    
    def snooze(ref_type, ref_id)
      Podio.connection.post("/reminder/#{ref_type}/#{ref_id}/snooze").body
    end

    def create(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/reminder/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end

    def update(ref_type, ref_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/reminder/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end
  end
  
end
