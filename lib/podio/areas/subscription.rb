module Podio
  module Subscription
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/subscription/#{id}").body
    end

    def find_by_reference(ref_type, ref_id)
      member Podio.connection.get("/subscription/#{ref_type}/#{ref_id}").body
    end

    def create(ref_type, ref_id)
      Podio.connection.post("/subscription/#{ref_type}/#{ref_id}").body['subscription_id']
    end

    def delete(id)
      Podio.connection.delete("/subscription/#{id}")
    end

    def delete_by_reference(ref_type, ref_id)
      Podio.connection.delete("/subscription/#{ref_type}/#{ref_id}")
    end
  end
end
