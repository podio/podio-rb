module Podio
  module Task
    include Podio::ResponseWrapper
    extend self

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/task/"
        req.body = attributes
      end

      response.body['task_id']
    end

    def complete(id)
      Podio.connection.post("/task/#{id}/complete").body
    end

    def incomplete(id)
      Podio.connection.post("/task/#{id}/incomplete").body
    end

    def find(id)
      member Podio.connection.get("/task/#{id}").body
    end

    def find_active(options={})
      collection Podio.connection.get("/task/active/").body
    end

    def find_completed
      list Podio.connection.get("/task/completed/").body
    end

    def find_delegated
      collection Podio.connection.get("/task/assigned/active/").body
    end
  end
end
