class Podio::Extension < ActivePodio::Base
  property :extension_id, :integer
  property :name, :string
  property :installation_url, :string
  property :status, :string
  property :created_on, :datetime
  property :ratings, :hash
  property :description, :string
  property :url_label, :string

  # Publisher
  property :publisher_name, :string
  property :publisher_url, :string
  property :publisher_mail, :string

  # Price
  property :price_model, :string
  property :price_from, :integer
  property :price_to, :integer
  property :price_desc, :string

  # Writing
  property :main_screenshot_id, :integer
  property :logo_id, :integer
  # Reading
  has_one :main_screenshot, :class => 'FileAttachment'
  has_one :logo, :class => 'FileAttachment'

  has_one :user, :class => 'User'
  has_many :other_screenshots, :class => 'FileAttachment'


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

    def find_all_by_status(status, options = {})
      list Podio.connection.get { |req|
        req.url("/extension/status/#{status}", options)
      }.body
    end

    def find_overview(options = {})
      response = Podio.connection.get { |req|
        req.url("/extension/overview", options)
      }.body

      response['popular'] = list(response['popular'])
      response['staffpicks'] = list(response['staffpicks'])
      response['recent'] = list(response['recent'])

      response
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
