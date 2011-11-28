class Podio::Recurrence < ActivePodio::Base
  property :recurrence_id, :integer
  property :name, :string
  property :config, :hash
  property :step, :integer
  property :until, :date

  alias_method :id, :recurrence_id
  delegate_to_hash :config, :days, :repeat_on, :setter => true
  
  class << self
    def delete(ref_type, ref_id)
      Podio.connection.delete("/recurrence/#{ref_type}/#{ref_id}").body
    end
    
    def update(ref_type, ref_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/recurrence/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end
  end
  
end
