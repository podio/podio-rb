class Podio::EmailSubscriptionSetting < ActivePodio::Base
  include ActivePodio::Updatable

  property :digest, :boolean
  property :bulletin, :boolean
  property :reference, :boolean
  property :message, :boolean
  property :reminder, :boolean
  property :space, :boolean
  property :subscription, :boolean
  property :push_notification, :boolean
  property :push_notification_sound, :boolean
  property :push_notification_browser, :boolean

  def self.find_for_current_user
    self.get_groups
  end

  def update
    self.class.update_groups(self.attributes)
  end

  class << self
    def get_groups()
      member Podio.connection.get { |req|
        req.url("/email/group/", {})
      }.body
    end

    def update_groups(options)
      Podio.connection.put { |req|
        req.url "/email/group/"
        req.body = options
      }.body
    end

    def unsubscribe(username)
      Podio.connection.post("/email/unsubscribe/#{username}").status
    end

    def get_global_email_as_vcard(name)
      Podio.connection.get("/email/contact/#{name}/vcard").body
    end

    def get_ref_email_as_vcard(name, ref_type, ref_id)
      Podio.connection.get("/email/contact/#{name}/#{ref_type}/#{ref_id}/vcard").body
    end

  end

end
