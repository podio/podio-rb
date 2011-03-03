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

    def create_with_ref(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/task/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end

      response.body['task_id']
    end

    def update_description(id, description)
      Podio.connection.put("/task/#{id}/description", {:description => description}).status
    end

    def update_text(id, text)
      Podio.connection.put("/task/#{id}/text", {:text => text}).status
    end

    def update_private(id, private_flag)
      Podio.connection.put("/task/#{id}/private", {:private => private_flag}).status
    end

    def update_due_date(id, due_date)
      Podio.connection.put("/task/#{id}/due_date", {:due_date => due_date}).status
    end

    def update_assignee(id, user_id)
      Podio.connection.post("/task/#{id}/assign", {:responsible => user_id}).status
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

    def rank(id, before_task_id, after_task_id)
      Podio.connection.post("/task/#{id}/rank", {:before => before_task_id, :after => after_task_id}).body
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
