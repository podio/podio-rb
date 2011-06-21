class Podio::Embed < ActivePodio::Base

  property :embed_id, :integer
  property :original_url, :string
  property :resolved_url, :string
  property :type, :string
  property :title, :string
  property :description, :string
  property :created_on, :datetime
  property :provider_name, :string
  property :embed_html, :string
  property :embed_height, :boolean
  property :embed_width, :integer

  has_many :files, :class => 'FileAttachment'

  alias_method :id, :embed_id

  class << self

    def create(url)
      response = Podio.connection.post do |req|
        req.url '/embed/'
        req.body = {:url => url }
      end
      member response.body
    end

    def find(id)
      member Podio.connection.get("/embed/#{id}").body
    end

  end
end