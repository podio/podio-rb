# @see https://developers.podio.com/doc/bulletins
class Podio::Bulletin < ActivePodio::Base
  property :bulletin_id, :integer
  property :title, :string
  property :summary, :string
  property :text, :string
  property :locale, :string
  property :target_group, :string
  property :created_on, :datetime
  property :sent_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :sent_by, :class => 'ByLine'

  alias_method :id, :bulletin_id

  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/bulletin/"
        req.body = attributes
      end

      response.body['bulletin_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/bulletin/#{id}"
        req.body = attributes
      end

      response.status
    end

    # @see https://developers.podio.com/doc/bulletins/get-bulletin-22415
    def find(id, options={})
      member Podio.connection.get("/bulletin/#{id}").body
    end

    def find_visible
      list Podio.connection.get("/bulletin/").body
    end

    # @see https://developers.podio.com/doc/bulletins/get-bulletins-22512
    def find_all
      list Podio.connection.get("/bulletin/?show_drafts=1").body
    end

    def find_all_by_locale(locale)
      list Podio.connection.get("/bulletin/?locale=locale").body
    end

    def preview!(id)
      Podio.connection.post("/bulletin/#{id}/preview").body
    end

    def send!(id)
      Podio.connection.post("/bulletin/#{id}/send").body
    end

  end
end
