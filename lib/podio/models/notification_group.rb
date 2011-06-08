# This class wraps the response from the Get Notifications API call
class Podio::NotificationGroup < ActivePodio::Base
  property :context, :hash
  property :notifications, :hash
  delegate_to_hash :context, :ref, :data
  delegate_to_hash :data, :link
end
