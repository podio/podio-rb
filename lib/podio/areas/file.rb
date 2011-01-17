module Podio
  module File
    include Podio::ResponseWrapper
    extend self

    # Uploading a file is a two-step operation
    # First, the file must be created to get a file id and the path to move it to
    def create(name, content_type)
      response = Podio.connection.post do |req|
        req.url "/file/"
        req.body = { :name => name, :mimetype => content_type }
      end

      response.body
    end
    
    # Then, when the file has been moved, it must be marked as available
    def set_available(file_id)
      Podio.connection.post "/file/#{file_id}/available"
    end
    
  end
end
