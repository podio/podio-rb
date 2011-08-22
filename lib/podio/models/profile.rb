# Serves as the base for Contacts and Organization Contacts
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

    def find(profile_id)
      member Podio.connection.get("/contact/#{profile_id}/v2").body
    end

    def find_all_for_org(org_id, options={})
      options[:type] ||= 'full'
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )

      list Podio.connection.get { |req|
        req.url("/contact/org/#{org_id}", options)
      }.body
    end

    def find_all_for_space(space_id, options={})
      options[:type] ||= 'full'
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )

      list Podio.connection.get { |req|
        req.url("/contact/space/#{space_id}", options)
      }.body
    end

    def find_all_for_connection(connection_id, options={})
      options[:type] ||= 'full'

      list Podio.connection.get { |req|
        req.url("/contact/connection/#{connection_id}", options)
      }.body      
    end

    def find_all_for_connection_type(connection_type, options={})
      options[:type] ||= 'full'

      list Podio.connection.get { |req|
        req.url("/contact/connection/#{connection_type}", options)
      }.body
    end
    
    def find_for_org(org_id)
      member Podio.connection.get("/org/#{org_id}/billing").body
    end

    def find_for_user(user_id)
      member Podio.connection.get("/contact/user/#{user_id}").body
    end

    def vcard(profile_id)
      Podio.connection.get("/contact/#{profile_id}/vcard").body
    end

    def totals_by_org
      Podio.connection.get("/contact/totals/").body
    end

    def totals_by_org_and_space
      Podio.connection.get("/contact/totals/v2/").body
    end

    def skills(options)
      Podio.connection.get { |req|
        req.url("/contact/skill/", options)
      }.body      
    end

    def totals_by_space(space_id, options = {})
      options[:exclude_self] = (options[:exclude_self] == false ? "0" : "1" )
      
      Podio.connection.get { |req|
        req.url("/contact/space/#{space_id}/totals/", options)
      }.body
    end

    def create_space_contact(space_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contact/space/#{space_id}/"
        req.body = attributes
      end

      response.body
    end
    
    def delete_contact(profile_id)
      Podio.connection.delete("/contact/#{profile_id}").body
    end

    def update_contact(profile_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/contact/#{profile_id}"
        req.body = attributes
      end

      response.body
    end
    
  end
end
