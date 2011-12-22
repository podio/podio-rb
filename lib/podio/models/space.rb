class Podio::Space < ActivePodio::Base
  include ActivePodio::Updatable
  
  property :space_id, :integer
  property :name, :string
  property :url, :string
  property :url_label, :string
  property :org_id, :integer
  property :contact_count, :integer
  property :members, :integer
  property :role, :string
  property :rights, :array
  property :post_on_new_app, :boolean
  property :post_on_new_member, :boolean
  property :subscribed, :boolean
  property :privacy, :string
  property :auto_join, :boolean
  property :type, :string
  property :premium, :boolean
  
  has_one :created_by, :class => 'ByLine'

  alias_method :id, :space_id
  
  def create
    response = Space.create(:org_id => org_id, :name => name, :privacy => self.privacy, :auto_join => self.auto_join)
    self.url = response['url']
    self.space_id = response['space_id']
  end
  
  def update
    self.class.update(self.space_id, :name => self.name, :post_on_new_app => self.post_on_new_app, :post_on_new_member => self.post_on_new_member, :url_label => self.url_label, :privacy => self.privacy, :auto_join => self.auto_join)
  end
  
  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/space/'
        req.body = attributes
      end

      response.body
    end

    def update(space_id, attributes)
      Podio.connection.put("/space/#{space_id}", attributes).status
    end

    def delete(id)
      Podio.connection.delete("/space/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/space/#{id}").body
    end
    
    def join(space_id)
      Podio.connection.post("/space/#{space_id}/join").body
    end

    def find_by_url(url, info = false)
      info = info ? 1 : 0
      member Podio.connection.get("/space/url?url=#{ERB::Util.url_encode(url)}&info=#{info}").body
    end
    
    def find_all_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/space/").body
    end

    def find_open_for_org(org_id)
      list Podio.connection.get("/space/org/#{org_id}/available/").body
    end
    
    def validate_url_label(org_id, url_label)
      Podio.connection.post { |req|
        req.url "/space/org/#{org_id}/url/validate"
        req.body = {:url_label => url_label}
      }.body
    end
    
  end
end

