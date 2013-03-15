# @see https://developers.podio.com/doc/spaces
class Podio::Space < ActivePodio::Base
  include ActivePodio::Updatable

  property :space_id, :integer
  property :name, :string
  property :url, :string
  property :url_label, :string
  property :org_id, :integer
  property :contact_count, :integer
  property :member_count, :integer
  property :app_count, :integer
  property :role, :string
  property :rights, :array
  property :post_on_new_app, :boolean
  property :post_on_new_member, :boolean
  property :subscribed, :boolean
  property :privacy, :string
  property :auto_join, :boolean
  property :type, :string
  property :premium, :boolean
  property :last_activity_on, :datetime
  property :created_on, :datetime
  property :is_overdue, :boolean
  property :push, :hash

  has_one :created_by, :class => 'ByLine'
  has_one :org, :class => 'Organization'

  alias_method :id, :space_id

  # @see https://developers.podio.com/doc/spaces/create-space-22390
  def create
    response = Space.create(:org_id => org_id, :name => name, :privacy => self.privacy, :auto_join => self.auto_join)
    self.url = response['url']
    self.space_id = response['space_id']
  end

  # @see https://developers.podio.com/doc/spaces/update-space-22391
  def update
    self.class.update(self.space_id, :name => self.name, :post_on_new_app => self.post_on_new_app, :post_on_new_member => self.post_on_new_member, :url_label => self.url_label, :privacy => self.privacy, :auto_join => self.auto_join)
  end

  def delete
    self.class.delete(self.id)
  end

  class << self
    # @see https://developers.podio.com/doc/spaces/create-space-22390
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/space/'
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/spaces/update-space-22391
    def update(space_id, attributes)
      Podio.connection.put("/space/#{space_id}", attributes).status
    end

    def delete(id)
      Podio.connection.delete("/space/#{id}").status
    end

    # @see https://developers.podio.com/doc/spaces/get-space-22389
    def find(id)
      member Podio.connection.get("/space/#{id}").body
    end

    # @see https://developers.podio.com/doc/space-members/join-space-1927286
    def join(space_id)
      Podio.connection.post("/space/#{space_id}/join").body
    end

    # @see https://developers.podio.com/doc/organizations/end-organization-membership-19410457
    def leave(space_id)
      Podio.connection.post("/space/#{space_id}/leave").status
    end

    # @see https://developers.podio.com/doc/spaces/get-space-by-url-22481
    def find_by_url(url)
      member Podio.connection.get("/space/url?url=#{ERB::Util.url_encode(url)}").body
    end

    def find_all_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/space/").body
    end

    def find_all_spaces_for_org(org_id, options={})
      list Podio.connection.get("/org/#{org_id}/all_spaces/", options).body
    end

    # @see https://developers.podio.com/doc/spaces/get-available-spaces-1911961
    def find_open_for_org(org_id)
      list Podio.connection.get("/space/org/#{org_id}/available/").body
    end

    def validate_url_label(org_id, url_label)
      Podio.connection.post { |req|
        req.url "/space/org/#{org_id}/url/validate"
        req.body = {:url_label => url_label}
      }.body
    end

    def get_overdue_info(space_id)
      Podio.connection.get("/space/#{space_id}/overdue").body
    end
    
    def get_count(org_id)
      Podio.connection.get("/space/org/#{org_id}").body['count']
    end

  end
end

