class Podio::News < ActivePodio::Base
  property :news_id, :integer
  property :title, :string
  property :content, :string
  property :link, :string

  alias_method :id, :news_id
  
  class << self
    def find_stream()
      Podio.connection.get("/news/stream").body
    end

    def get_news_redirect(news_id, type=nil)
      type = type.presence || 'stream'
      response = Podio.connection.get("/news/#{news_id}/redirect?type=#{type}")
      response.body['link']
    end

    def delete(news_id)
      Podio.connection.delete("/news/#{news_id}")
    end

    def unsubscribe_entry(news_id)
      Podio.connection.post do |req|
        req.url "/news/#{news_id}/unsubscribe"
      end
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/news/'
        req.body = attributes
      end
      response.body['news_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/news/#{id}"
        req.body = attributes
      end

      response.status
    end

    def find(id, options={})
      member Podio.connection.get("/news/#{id}").body
    end

    def find_visible
      list Podio.connection.get("/news/").body
    end

    def find_all
      list Podio.connection.get("/news/").body
    end

    def find_all_by_locale(locale)
      list Podio.connection.get('/news/?locale=#{locale}').body
    end

    def find_all_by_target_group(target_group)
      list Podio.connection.get('/news/?target_group=#{target_group}').body
    end

    def find_all_by_locale_and_group(locale, group)
      list Podio.connection.get('/news/?locale=#{locale}?target_group=#{group}').body
    end
    
  end
end