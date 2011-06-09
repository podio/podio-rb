class Podio::FileAttachment < ActivePodio::Base
  property :file_id, :integer
  property :link, :string
  property :name, :string
  property :description, :string
  property :mimetype, :string
  property :size, :integer
  property :created_on, :datetime
  
  has_one :created_by, :class => Podio::ByLine
  has_one :created_via, :class => Podio::Via
  has_many :replaces, :class => Podio::FileAttachment
  
  alias_method :id, :file_id

  # Uploads the given file, moves it to its proper place and marks it as available
  def self.create(name, content_type, source_path)
    upload_info = super(name, content_type)
    destination_path = File.join(PODIO_FILESERVER_CONFIG[Rails.env][:mount], upload_info['location'])
    FileUtils.move(source_path, destination_path)
    self.set_available(upload_info['file_id'])
    return self.new(:file_id => upload_info['file_id'])
  end
  
  def image?
    ['image/png', 'image/jpeg', 'image/gif', 'image/tiff', 'image/bmp'].include?(self.mimetype)
  end
end