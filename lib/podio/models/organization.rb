class Podio::Organization < ActivePodio::Base
  include ActivePodio::Updatable

  property :org_id, :integer
  property :name, :string
  property :logo, :integer
  property :image, :hash
  property :spaces, :hash
  property :url, :string
  property :url_label, :string
  property :premium, :boolean
  property :role, :string
  property :status, :string
  property :sales_agent_id, :integer
  property :created_on, :datetime
  property :user_limit, :integer
  property :member_count, :integer
  property :contact_count, :integer
  property :billing_interval, :integer
  property :rights, :array

  has_one :created_by, :class => 'ByLine'

  alias_method :id, :org_id

  def create
    attributes = Organization.create(:name => name)
    self.org_id = attributes['org_id']
    self.url = attributes['url']
    self.url_label = attributes['url_label']
  end

  def update
    Organization.update(id, {:name => name, :logo => logo, :url_label => url_label, :billing_interval => billing_interval})
  end
  
  handle_api_errors_for :create, :update # Call must be made after the methods to handle have been defined  
  
  class << self
    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/org/#{id}"
        req.body = attributes
      end
      response.status
    end

    def delete(id)
      Podio.connection.delete("/org/#{id}").status
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/org/'
        req.body = attributes
      end

      response.body
    end

    def find(id)
      member Podio.connection.get("/org/#{id}").body
    end

    def find_by_url(url)
      member Podio.connection.get("/org/url?url=#{url}").body
    end

    def validate_url_label(url_label)
      Podio.connection.post { |req|
        req.url '/org/url/validate'
        req.body = {:url_label => url_label}
      }.body
    end

    def find_all
      list Podio.connection.get("/org/").body
    end

    def find_orgs_and_spaces_for_navigation
      Podio.connection.get("/org/v2/").body
    end
    
    def get_statistics(id)
      Podio.connection.get("/org/#{id}/statistics").body
    end
    
    def get_login_report(id, options = {})
      Podio.connection.get { |req|
        req.url("/org/#{id}/report/login/", options)
      }.body
    end
    
    def update_billing_profile(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/org/#{id}/billing"
        req.body = attributes
      end
      response.status
    end

    def upgrade(id)
      Podio.connection.post("/org/#{id}/upgrade").body
    end
    
    def set_joined_as(org_id, joined_as_type, joined_as_id)
      Podio.connection.post { |req|
        req.url "/org/#{org_id}/joined_as"
        req.body = {:type => joined_as_type, :id => joined_as_id}
      }.body
    end
    
  end
end
