# @see https://developers.podio.com/doc/email
class Podio::EmailSubscriptionSetting < ActivePodio::Base
  include ActivePodio::Updatable

  property :digest, :boolean
  property :reference, :boolean
  property :message, :boolean
  property :reminder, :boolean
  property :space, :boolean
  property :subscription, :boolean
  property :push_notification, :boolean
  property :push_notification_sound, :boolean
  property :push_notification_browser, :boolean
  property :user, :boolean
  property :bulletin, :boolean

  def self.find_for_current_user
    self.get_groups
  end

  def update
    self.class.update_groups(self.attributes)
  end

  class << self
    # @see https://developers.podio.com/doc/email/get-groups-333977
    def get_groups()
      member Podio.connection.get { |req|
        req.url("/email/group/", {})
      }.body
    end

    # @see https://developers.podio.com/doc/email/update-groups-333981
    def update_groups(options)
      Podio.connection.put { |req|
        req.url "/email/group/"
        req.body = options
      }.body
    end

    # @see https://developers.podio.com/doc/email/unsubscribe-from-all-304917
    def unsubscribe(username)
      Podio.connection.post("/email/unsubscribe/#{username}").status
    end

  end

end
