# Serves as the base for Contacts and Organization Contacts
# @see https://developers.podio.com/doc/contacts
class Podio::Profile < ActivePodio::Base
  property :profile_id, :integer
  property :name, :string
  property :avatar, :integer
  property :image, :hash
  property :birthdate, :date
  property :department, :string
  property :vatin, :string
  property :skype, :string
  property :about, :string
  property :address, :array
  property :zip, :string
  property :city, :string
  property :country, :string
  property :state, :string
  property :im, :array
  property :location, :array
  property :mail, :array
  property :phone, :array
  property :title, :array
  property :url, :array
  property :skill, :array
  property :linkedin, :string
  property :twitter, :string

  property :app_store_about, :string
  property :app_store_organization, :string
  property :app_store_location, :string
  property :app_store_title, :string
  property :app_store_url, :string

  property :last_seen_on, :datetime
  property :is_employee, :boolean

  alias_method :employee?, :is_employee

  class << self
    def all(options={})
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )

      list Podio.connection.get { |req|
        req.url("/contact/", options)
      }.body
    end

    def top(options={})
      list Podio.connection.get { |req|
        req.url("/contact/top/", options)
      }.body
    end

    def top_for_space(space_id, options={})
      list Podio.connection.get { |req|
        req.url("/contact/space/#{space_id}/top/", options)
      }.body
    end

    def top_for_org(org_id, options={})
      list Podio.connection.get { |req|
        req.url("/contact/org/#{org_id}/top/", options)
      }.body
    end

    def top_for_personal(options={})
      list Podio.connection.get { |req|
        req.url("/contact/personal/top/", options)
      }.body
    end

    def find(profile_id, options = {})
      result = Podio.connection.get do |req|
        req.url("/contact/#{profile_id}/v2", options)
      end.body

      if result.is_a?(Array)
        return list result
      else
        return member result
      end
    end

    # @see https://developers.podio.com/doc/contacts/get-organization-contacts-22401
    def find_all_for_org(org_id, options={})
      options[:view] ||= 'full'
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )

      list Podio.connection.get { |req|
        req.url("/contact/org/#{org_id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/contacts/get-space-contacts-22414
    def find_all_for_space(space_id, options={})
      options[:view] ||= 'full'
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )

      list Podio.connection.get { |req|
        req.url("/contact/space/#{space_id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/contacts/get-contacts-by-connection-id-60493
    def find_all_for_connection(connection_id, options={})
      options[:view] ||= 'full'

      list Podio.connection.get { |req|
        req.url("/contact/connection/#{connection_id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/contacts/get-contacts-by-connection-type-60496
    def find_all_for_connection_type(connection_type, options={})
      options[:view] ||= 'full'

      list Podio.connection.get { |req|
        req.url("/contact/connection/#{connection_type}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/contacts/get-linked-account-contacts-6214688
    def find_all_for_linked_account(id, options={})
      list Podio.connection.get { |req|
        req.url("/contact/linked_account/#{id}", options)
      }.body
    end

    def find_for_org(org_id)
      member Podio.connection.get("/org/#{org_id}/billing").body
    end

    # @see https://developers.podio.com/doc/contacts/get-user-contact-60514
    def find_for_user(user_id)
      member Podio.connection.get("/contact/user/#{user_id}").body
    end

    # @see https://developers.podio.com/doc/contacts/get-user-contact-60514
    def find_all_for_users(user_ids)
      list Podio.connection.get("/contact/user/#{user_ids}").body
    end

    # @see https://developers.podio.com/doc/contacts/get-vcard-213496
    def vcard(profile_id)
      Podio.connection.get("/contact/#{profile_id}/vcard").body
    end

    def totals_by_org
      Podio.connection.get("/contact/totals/").body
    end

    # @see https://developers.podio.com/doc/contacts/get-space-contact-totals-67508
    def totals_by_space_v2(space_id)
      Podio.connection.get("/contact/space/#{space_id}/totals/space").body
    end

    # @see https://developers.podio.com/doc/contacts/get-contact-totals-60467
    def totals_by_org_and_space
      Podio.connection.get("/contact/totals/v2/").body
    end

    # @see https://developers.podio.com/doc/contacts/get-skills-1346872
    def skills(options)
      Podio.connection.get { |req|
        req.url("/contact/skill/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/contacts/get-space-contact-totals-67508
    def totals_by_space(space_id, options = {})
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )

      Podio.connection.get { |req|
        req.url("/contact/space/#{space_id}/totals/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/contacts/create-space-contact-65590
    def create_space_contact(space_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contact/space/#{space_id}/"
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/contacts/delete-contact-s-60560
    def delete_contact(profile_id)
      Podio.connection.delete("/contact/#{profile_id}").body
    end

    # @see https://developers.podio.com/doc/contacts/update-contact-60556
    def update_contact(profile_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/contact/#{profile_id}"
        req.body = attributes
      end

      response.body
    end

  end
end
