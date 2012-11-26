# This class wraps the response from the Get Notifications API call
# @see https://developers.podio.com/doc/notifications
class Podio::NotificationGroup < ActivePodio::Base
  property :context, :hash
  property :notifications, :hash
  delegate_to_hash :context, :ref, :data, :comment_count, :link, :space, :rights

  class << self
    # @see https://developers.podio.com/doc/notifications/get-notifications-290777
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/notification/', options)
      }.body
    end

    # @see https://developers.podio.com/doc/notifications/get-notification-v2-2973737
    def find(id)
      member Podio.connection.get("/notification/#{id}/v2").body
    end

    # @see https://developers.podio.com/doc/notifications/mark-notifications-as-viewed-by-ref-553653
    def mark_as_viewed_by_ref(ref_type, ref_id)
      Podio.connection.post("/notification/#{ref_type}/#{ref_id}/viewed").status
    end
  end
end
