module Podio
  module Tag
    include Podio::ResponseWrapper
    extend self

    def create(tagable_type, tagable_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/tag/#{tagable_type}/#{tagable_id}/"
        req.body = attributes
      end

      response.body
    end

    def update(tagable_type, tagable_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/tag/#{tagable_type}/#{tagable_id}/"
        req.body = attributes
      end

      response.body
    end

    def find_by_app(app_id, limit, text)
      list Podio.connection.get("/tag/app/#{app_id}/?limit=#{limit}&text=#{text}").body
    end

    def find_top_by_app(app_id, limit, text)
      Podio.connection.get("/tag/app/#{app_id}/top/?limit=#{limit}&text=#{text}").body
    end

  end

end
