class Podio::Importer < ActivePodio::Base

  class << self
    def process_file(file_id, options = {})
      response = Podio.connection.post do |req|
        req.url "/importer/#{file_id}/process"
        req.body = options
      end

      response.body
    end

    def get_columns(file_id)
      list Podio.connection.get("/importer/#{file_id}/column/").body
    end

    def get_info(file_id)
      Podio.connection.get("/importer/#{file_id}/info").body
    end

    def preview(file_id, row, options)
      response = Podio.connection.post do |req|
        req.url "/importer/#{file_id}/preview/#{row}"
        req.body = options
      end

      response.body
    end

  end
end
