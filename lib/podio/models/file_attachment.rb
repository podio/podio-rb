class Podio::FileAttachment < ActivePodio::Base
  property :file_id, :integer
  property :link, :string
  property :name, :string
  property :description, :string
  property :mimetype, :string
  property :size, :integer
  property :created_on, :datetime
  
  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_many :replaces, :class => 'FileAttachment'
  
  alias_method :id, :file_id

  def image?
    ['image/png', 'image/jpeg', 'image/gif', 'image/tiff', 'image/bmp'].include?(self.mimetype)
  end
  
  class << self

    # Accepts an open file stream along with a content type and a file name and uploads the file to Podio
    # Returns an instantiated FileAttachment model with id, link, name and mimetype set
    # If you use Ruby on Rails 3 or higher you can also pass the file in params directly to +upload_from_rails_param+
    def upload(file_stream, content_type, file_name)
      response = Podio.client.raw_connection.post do |req|
        req.url "/file/v2/"
        req.body = {:source => Faraday::UploadIO.new(file_stream, content_type, file_name), :filename => file_name}
      end
      file_attributes = ActiveSupport::JSON.decode(response.body) # Using raw_connection means response is not automatically decoded to json
      file_attributes.merge!(:name => file_name, :mimetype => content_type)
      member file_attributes
    end
    
    # Accepts a ActionDispatch::Http::UploadedFile or similar and uploads the file to Podio
    # Optionally attaches the file to the given ref type and ref id
    # Returns an instantiated FileAttachment model with id, link, name and mimetype set
    def upload_from_rails_param(uploaded_file, ref_type = nil, ref_id = nil)
      p uploaded_file
      file_attachment = self.upload(uploaded_file.tempfile, uploaded_file.content_type, uploaded_file.original_filename)
      if ref_type.present? && ref_id.present?
        self.attach(file_attachment.id, ref_type, ref_id)
      end
      file_attachment
    end
    
    # Attach a file to an existing reference
    def attach(id, ref_type, ref_id)
      Podio.connection.post do |req|
        req.url "/file/#{id}/attach"
        req.body = { :ref_type => ref_type, :ref_id => ref_id }
      end
    end

    def copy(id)
      Podio.connection.post("/file/#{id}/copy").body['file_id']
    end
    
    def delete(id)
      Podio.connection.delete("/file/#{id}")
    end
    
    def find(id)
      member Podio.connection.get("/file/#{id}").body
    end

    def find_for_app(app_id, options={})
      collection Podio.connection.get { |req|
        req.url("/file/app/#{app_id}/", options)
      }.body
    end

    def find_for_space(space_id, options={})
      collection Podio.connection.get { |req|
        req.url("/file/space/#{space_id}/", options)
      }.body
    end

    def find_latest_for_app(app_id, options={})
      collection Podio.connection.get { |req|
        req.url("/file/app/#{app_id}/latest/", options)
      }.body
    end

    def find_latest_for_space(space_id, options={})
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
    
    
    #
    # Obsolete way of uploading files, use upload method instead
    #
    
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
    
  end
end