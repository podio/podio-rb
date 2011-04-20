module Podio
  module Tag
    include Podio::ResponseWrapper
    extend self

    def find_by_app(app_id, limit, text)
      list Podio.connection.get("/tag/app/#{app_id}/?limit=#{limit}&text=#{text}").body
    end

    def find_top_by_app(app_id, limit, text)
      list Podio.connection.get("/tag/app/#{app_id}/top/?limit=#{limit}&text=#{text}").body
    end

  end

end
