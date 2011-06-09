class Podio::AppStoreShare < ActivePodio::Base
  property :share_id, :integer
  property :type, :string
  property :status, :string
  property :parents, :hash
  property :name, :string
  property :description, :string
  property :abstract, :string
  property :language, :string
  property :featured, :boolean
  property :features, :array
  property :filters, :array
  property :integration, :string
  property :categories, :hash
  property :org, :hash
  property :author, :hash
  property :author_apps, :integer
  property :author_packs, :integer
  property :icon, :string
  property :comments, :array
  property :ratings, :hash
  property :user_rating, :array
  property :screenshots, :array
  property :info, :hash
  
  has_many :children, :class => Podio::AppStoreShare
  has_one :author, :class => Podio::ByLine
  
  alias_method :id, :share_id

  def create
    self.share_id = self.class.create(self.attributes)
  end

  def install(space_id, dependencies)
    self.class.install(self.share_id, space_id, dependencies)
  end
  
  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app_store/"
        req.body = attributes
      end

      response.body['share_id']
    end

    def install(share_id, space_id, dependencies)
      response = Podio.connection.post do |req|
        req.url "/app_store/#{share_id}/install/v2"
        req.body = {:space_id => space_id, :dependencies => dependencies}
      end

      response.body
    end

    def find(id)
      member Podio.connection.get("/app_store/#{id}/v2").body
    end

    def find_all_private_for_org(org_id)
      list Podio.connection.get("/app_store/org/#{org_id}/").body['shares']
    end
  end
end

