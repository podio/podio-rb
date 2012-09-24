# @see https://developers.podio.com/doc/email
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

    # @see https://developers.podio.com/doc/email/get-global-email-contact-as-vcard-13624848
    def get_global_email_as_vcard(name)
      Podio.connection.get("/email/contact/#{name}/vcard").body
    end

    # @see https://developers.podio.com/doc/email/get-email-contact-for-reference-as-vcard-13628255
    def get_ref_email_as_vcard(name, ref_type, ref_id)
      Podio.connection.get("/email/contact/#{name}/#{ref_type}/#{ref_id}/vcard").body
    end

    # @see https://developers.podio.com/doc/email/export-global-email-contact-to-linked-account-13629508
    def export_global_contact_to_linked_acc(name, linked_acc_id)
      Podio.connection.post { |req|
        req.url "/email/contact/#{name}/export"
        req.body = { :linked_account_id => linked_acc_id }
      }.body
    end

    # @see https://developers.podio.com/doc/email/export-email-contact-for-reference-to-linked-account-13628926
    def export_ref_contact_to_linked_acc(name, ref_type, ref_id, linked_acc_id)
      Podio.connection.post { |req|
        req.url "/email/contact/#{name}/#{ref_type}/#{ref_id}/export"
        req.body = { :linked_account_id => linked_acc_id }
      }.body
    end

  end

end
