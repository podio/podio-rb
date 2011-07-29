# This class wraps the response from the Get Notifications API call
class Podio::NotificationGroup < ActivePodio::Base
  property :context, :hash
  property :notifications, :hash
  delegate_to_hash :context, :ref, :data, :comment_count
  delegate_to_hash :data, :link
  
  class << self
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/notification/', options)
      }.body
    end
    
    def mark_as_viewed_by_ref(ref_type, ref_id)
      Podio.connection.post("/notification/#{ref_type}/#{ref_id}/viewed").status
    end
  end
end
