# https://developers.podio.com/doc/subscriptions
class Podio::Subscription < ActivePodio::Base
  property :started_on, :datetime
  property :notifications, :integer
  property :ref, :hash

  class << self
    # https://developers.podio.com/doc/subscriptions/get-subscription-by-id-22446
    def find(id)
      member Podio.connection.get("/subscription/#{id}").body
    end

    # https://developers.podio.com/doc/subscriptions/get-subscription-by-reference-22408
    def find_by_reference(ref_type, ref_id)
      member Podio.connection.get("/subscription/#{ref_type}/#{ref_id}").body
    end

    # https://developers.podio.com/doc/subscriptions/subscribe-22409
    def create(ref_type, ref_id)
      Podio.connection.post("/subscription/#{ref_type}/#{ref_id}").body['subscription_id']
    end

    # https://developers.podio.com/doc/subscriptions/unsubscribe-by-id-22445
    def delete(id)
      Podio.connection.delete("/subscription/#{id}")
    end

    # https://developers.podio.com/doc/subscriptions/unsubscribe-by-reference-22410
    def delete_by_reference(ref_type, ref_id)
      Podio.connection.delete("/subscription/#{ref_type}/#{ref_id}")
    end

    def find_subscribers_by_reference(ref_type, ref_id)
      User.list Podio.connection.get("/subscription/#{ref_type}/#{ref_id}/").body
    end
  end
end
