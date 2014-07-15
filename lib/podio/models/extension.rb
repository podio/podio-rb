class Podio::Extension < ActivePodio::Base
  property :extension_id, :integer
  property :name, :string
  property :installation_url, :string
  property :status, :string

  # Publisher
  property :publisher_name, :string
  property :publisher_url, :string
  property :publisher_mail, :string
  property :logo_id, :integer

  # Price
  property :price_model, :string
  property :price_from, :integer
  property :price_to, :integer
  property :price_desc, :string

  property :main_screenshot_id, :integer

  has_one :user, :class => 'User'

  class << self
    def create(attributes, options={})
      response = Podio.connection.post do |req|
        req.url("/extension/", options)
        req.body = attributes
      end

      response.body
    end

    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url("/extension/", options)
      }.body
    end

    def find_all_for_current_user(options = {})
      list Podio.connection.get { |req|
        req.url("/extension/user/", options)
      }.body
    end

    def find(id)
      member Podio.connection.get("/extension/#{id}").body
    end

    def update(id, attributes, options={})
      response = Podio.connection.put do |req|
        req.url("/extension/#{id}", options)
        req.body = attributes
      end
      response.status
    end

    def delete(id)
      Podio.connection.delete("/extension/#{id}").body
    end

  end
end
