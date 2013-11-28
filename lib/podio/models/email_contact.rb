# @see https://developers.podio.com/doc/email
class Podio::EmailContact < ActivePodio::Base

  property :name, :string
  property :mail, :string

  class << self
    # @see https://developers.podio.com/doc/email/get-global-contact-13716154
    def get_global(name)
      member Podio.connection.get("/email/contact/#{name}").body
    end

    # @see https://developers.podio.com/doc/email/get-email-contact-for-reference-13716555
    def get_ref(name, ref_type, ref_id)
      member Podio.connection.get("/email/contact/#{name}/#{ref_type}/#{ref_id}").body
    end

    # @see https://developers.podio.com/doc/email/get-global-email-contact-as-vcard-13624848
    def get_global_as_vcard(name)
      Podio.connection.get("/email/contact/#{name}/vcard").body
    end

    # @see https://developers.podio.com/doc/email/get-email-contact-for-reference-as-vcard-13628255
    def get_ref_as_vcard(name, ref_type, ref_id)
      Podio.connection.get("/email/contact/#{name}/#{ref_type}/#{ref_id}/vcard").body
    end

    # @see https://developers.podio.com/doc/email/export-global-email-contact-to-linked-account-13629508
    def export_global(name, linked_acc_id)
      Podio.connection.post { |req|
        req.url "/email/contact/#{name}/export"
        req.body = { :linked_account_id => linked_acc_id }
      }.body
    end

    # @see https://developers.podio.com/doc/email/export-email-contact-for-reference-to-linked-account-13628926
    def export_ref(name, ref_type, ref_id, linked_acc_id)
      Podio.connection.post { |req|
        req.url "/email/contact/#{name}/#{ref_type}/#{ref_id}/export"
        req.body = { :linked_account_id => linked_acc_id }
      }.body
    end

  end

end
