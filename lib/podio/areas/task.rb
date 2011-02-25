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

    def delete(id)
      Podio.connection.delete("/task/#{id}").status
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

    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/task/', options)
      }.body
    end
  end
end
