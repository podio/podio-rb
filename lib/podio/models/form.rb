class Podio::Form < ActivePodio::Base
  property :form_id, :integer
  property :app_id, :integer
  property :settings, :hash
  property :domains, :array
  property :field_ids, :array
  property :attachments, :boolean
  
  alias_method :id, :form_id
  
  class << self
    def find(form_id)
      member Podio.connection.get("/form/#{form_id}").body
    end
    
  end
end