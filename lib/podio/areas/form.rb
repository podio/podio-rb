module Podio
  module Form
    include Podio::ResponseWrapper
    extend self
    
    def find(form_id)
      member Podio.connection.get("/form/#{form_id}").body
    end
    
  end
end