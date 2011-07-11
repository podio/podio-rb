class Podio::Space < ActivePodio::Base
  property :space_id, :integer
  property :name, :string
  property :url, :string
  property :url_label, :string
  property :org_id, :integer
  property :contact_count, :integer
  property :members, :integer
  property :role, :string
  property :rights, :array
  property :post_on_new_app, :bool
  property :post_on_new_member, :bool
  
  has_one :created_by, :class => 'ByLine'

  alias_method :id, :space_id
  
  def create
    response = Space.create(:org_id => org_id, :name => name)
    self.url = response['url']
    self.space_id = response['space_id']
  end
  
  def update
    self.class.update(self.space_id, :name => self.name, :post_on_new_app => self.post_on_new_app, :post_on_new_member => self.post_on_new_member, :url_label => self.url_label)
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

    def find_by_url(url)
      member Podio.connection.get("/space/url?url=#{ERB::Util.url_encode(url)}").body
    end
    
    def find_all_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/space/").body
    end
    
    def validate_url_label(org_id, url_label)
      Podio.connection.post { |req|
        req.url "/space/org/#{org_id}/url/validate"
        req.body = {:url_label => url_label}
      }.body
    end
    
  end
end

