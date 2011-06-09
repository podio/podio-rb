module Podio
  module Comment
    include Podio::ResponseWrapper
    extend self

    def create(commentable_type, commentable_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/comment/#{commentable_type}/#{commentable_id}"
        req.body = attributes
      end

      response.body['comment_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/comment/#{id}"
        req.body = attributes
      end

      response.status
    end

    def delete(id)
      Podio.connection.delete("/comment/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/comment/#{id}").body
    end

    def find_all_for(commentable_type, commentable_id)
      list Podio.connection.get("/comment/#{commentable_type}/#{commentable_id}").body
    end

    def find_recent_for_share
      #Internal
      list Podio.connection.get("/comment/share/").body
    end
  end
end
