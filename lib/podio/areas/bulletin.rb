module Podio
  module Bulletin
    include Podio::ResponseWrapper
    extend self

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

    def find(id, options={})
      member Podio.connection.get("/bulletin/#{id}").body
    end

    def find_visible
      list Podio.connection.get("/bulletin/").body
    end

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
