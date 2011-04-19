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
    def set_available(id)
      Podio.connection.post "/file/#{id}/available"
    end
    
    # Attach a file to an existing reference
    def attach(id, ref_type, ref_id)
      Podio.connection.post do |req|
        req.url "/file/#{id}/attach"
        req.body = { :ref_type => ref_type, :ref_id => ref_id }
      end
    end
    
    def copy(id)
      Podio.connection.post("/file/#{id}/copy").body['id']
    end
    
    def delete(id)
      Podio.connection.delete("/file/#{id}")
    end
    
    def find(id)
      member Podio.connection.get("/file/#{id}").body
    end

    def find_for_app(app_id, options={})
      options.assert_valid_keys(:limit, :offset)

      collection Podio.connection.get { |req|
        req.url("/file/app/#{app_id}/", options)
      }.body
    end

    def find_for_space(space_id, options={})
      options.assert_valid_keys(:limit, :offset)

      collection Podio.connection.get { |req|
        req.url("/file/space/#{space_id}/", options)
      }.body
    end

    def find_latest_for_app(app_id, options={})
      options.assert_valid_keys(:limit, :offset)

      collection Podio.connection.get { |req|
        req.url("/file/app/#{app_id}/latest/", options)
      }.body
    end

    def find_latest_for_space(space_id, options={})
      options.assert_valid_keys(:limit, :offset)

      collection Podio.connection.get { |req|
        req.url("/file/space/#{space_id}/latest/", options)
      }.body
    end
    
    def replace(old_file_id, new_file_id)
      Podio.connection.post { |req|
        req.url "/file/#{new_file_id}/replace"
        req.body = { :old_file_id => old_file_id }
      }.body
    end

    def update(id, description)
      Podio.connection.put { |req|
        req.url "/file/#{file_id}"
        req.body = { :description => description }
      }.body
    end
    
  end
end
