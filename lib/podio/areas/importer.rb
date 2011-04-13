module Podio
  module Importer
    include Podio::ResponseWrapper
    extend self

    def process_file(file_id, app_id, external_id, mapping)
      response = Podio.connection.post do |req|
        req.url "/importer/#{file_id}/process"
        req.body = {
          :app_id => app_id,
          :external_id => external_id,
          :mapping => mapping
        }
      end

      response.body
    end

    def get_columns(file_id)
      list Podio.connection.get("/importer/#{file_id}/column/").body
    end
    
  end
end
