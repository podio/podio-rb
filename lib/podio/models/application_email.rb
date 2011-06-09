class ApplicationEmail < ActivePodio::Base
  include ActivePodio::Updatable

  property :attachments, :boolean
  property :mappings, :hash  

  class << self
    def get_app_configuration(app_id)
      member Podio.connection.get { |req|
        req.url("/email/app/#{app_id}", {})
      }.body
    end

    def update_app_configuration(app_id, options)
      Podio.connection.put { |req|
        req.url "/email/app/#{app_id}"
        req.body = options
      }.body
    end
    
  end
end
