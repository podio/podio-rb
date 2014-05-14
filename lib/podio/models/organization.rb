# @see https://developers.podio.com/doc/organizations
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
  property :verified_domain, :string # TODO: Remove this, it's deprecated
  property :domains, :array
  property :rank, :integer
  property :contract_status, :string
  property :type, :string
  property :segment, :string
  property :segment_size, :integer
  property :grants_count, :integer
  property :allow_add_space, :boolean
  property :item_limit, :integer
  property :item_usage, :integer
  property :price_plans, :hash
  property :current_price_plan, :hash
  property :price_plans_variation, :string

  has_one :created_by, :class => 'ByLine'

  alias_method :id, :org_id

  # @see https://developers.podio.com/doc/organizations/add-new-organization-22385
  def create
    attributes = Organization.create(:name => name, :logo => logo, :segment_size => segment_size)
    self.org_id = attributes['org_id']
    self.url = attributes['url']
    self.url_label = attributes['url_label']
  end

  # @see https://developers.podio.com/doc/organizations/update-organization-22386
  def update
    Organization.update(id, {:name => name, :logo => logo, :url_label => url_label, :billing_interval => billing_interval, :segment_size => segment_size})
  end

  class << self
    # @see https://developers.podio.com/doc/organizations/update-organization-22386
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

    # @see https://developers.podio.com/doc/organizations/add-new-organization-22385
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/org/'
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/organizations/get-organization-22383
    def find(id, options={})
      member Podio.connection.get { |req|
        req.url("/org/#{id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/organizations/get-organization-by-url-22384
    def find_by_url(url)
      member Podio.connection.get("/org/url?url=#{url}").body
    end

    def find_by_url_slug(org_slug, options={})
      options['org_slug'] = org_slug

      member Podio.connection.get { |req|
        req.url('/org/url', options)
      }.body
    end

    def validate_url_label(url_label)
      Podio.connection.post { |req|
        req.url '/org/url/validate'
        req.body = {:url_label => url_label}
      }.body
    end

    # @see https://developers.podio.com/doc/organizations/get-organizations-22344
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/org/", options)
      }.body
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

    def find_all_with_private_shares
      list Podio.connection.get("/app_store/org/").body
    end

    def get_statistics(id)
      Podio.connection.get("/org/#{id}/statistics/v2").body
    end

    def find_for_user(user_id)
      list Podio.connection.get("/org/user/#{user_id}/").body
    end

    def change_to_user_model(id)
      Podio.connection.post("/org/#{id}/change_to_user_model").body
    end

  end
end
