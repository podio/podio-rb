class Podio::FileAttachment < ActivePodio::Base
  property :file_id, :integer
  property :link, :string
  property :name, :string
  property :description, :string
  property :mimetype, :string
  property :size, :integer
  property :context, :hash
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_many :replaces, :class => 'FileAttachment'

  alias_method :id, :file_id

  def image?
    ['image/png', 'image/jpeg', 'image/gif', 'image/bmp'].include?(self.mimetype)
  end

  def api_friendly_ref_type
    'file'
  end

  class << self
    # Accepts an open file stream along with a file name and uploads the file to Podio
    def upload(file_stream, file_name)
      response = Podio.client.raw_connection.post do |req|
        req.options[:timeout] = 1200
        req.url "/file/v2/"
        req.body = {:source => Faraday::UploadIO.new(file_stream, nil, nil), :filename => file_name}
      end

      member response.body
    end

    def upload_from_url(url)
      response = Podio.client.connection.post do |req|
        req.url "/file/from_url/"
        req.body = {:url => url}
      end

      member response.body
    end

    # Attach a file to an existing reference
    def attach(id, ref_type, ref_id)
      Podio.connection.post do |req|
        req.url "/file/#{id}/attach"
        req.body = {:ref_type => ref_type, :ref_id => ref_id}
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

    def find_raw(id)
      Podio.client.raw_connection.get("/file/#{id}/raw").body
    end

    def find_for_app(app_id, options={})
      list Podio.connection.get { |req|
        req.url("/file/app/#{app_id}/", options)
      }.body
    end

    def find_for_space(space_id, options={})
      list Podio.connection.get { |req|
        req.url("/file/space/#{space_id}/", options)
      }.body
    end

    def find_latest_for_app(app_id, options={})
      list Podio.connection.get { |req|
        req.url("/file/app/#{app_id}/latest/", options)
      }.body
    end

    def find_latest_for_space(space_id, options={})
      list Podio.connection.get { |req|
        req.url("/file/space/#{space_id}/latest/", options)
      }.body
    end

    def find_for_google(linked_account_id, options={})
      list Podio.connection.get { |req|
        req.url("/file/google/#{linked_account_id}/", options)
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
