class Podio::AppStoreShare < ActivePodio::Base
  property :share_id, :integer
  property :type, :string
  property :status, :string
  property :name, :string
  property :description, :string
  property :abstract, :string
  property :language, :string
  property :features, :array
  property :filters, :array
  property :integration, :string
  property :categories, :hash
  property :org, :hash
  property :author_apps, :integer
  property :author_packs, :integer
  property :icon, :string
  property :icon_id, :integer
  property :ratings, :hash
  property :user_rating, :array
  property :video, :string
  property :rating, :integer

  has_many :children, :class => 'AppStoreShare'
  has_many :parents, :class => 'AppStoreShare'
  has_many :screenshots, :class => 'FileAttachment'
  has_many :comments, :class => 'Comment'
  has_one :author, :class => 'ByLine'
  has_one :space, :class => 'Space'
  has_one :app, :class => 'Application'

  alias_method :id, :share_id

  def create
    self.share_id = self.class.create(self.attributes)
  end

  def destroy
    self.class.destroy(self.share_id)
  end

  def install(space_id, dependencies)
    self.class.install(self.share_id, space_id, dependencies)
  end

  handle_api_errors_for :create, :install  # Call must be made after the methods to handle have been defined

  def api_friendly_ref_type
    'share'
  end

  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app_store/"
        req.body = attributes
      end

      response.body['share_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/app_store/#{id}"
        req.body = attributes
      end
    end

    def destroy(id)
      response = Podio.connection.delete do |req|
        req.url "/app_store/#{id}"
      end
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

    def find_all_own(options = {})
      shares_collection Podio.connection.get { |req|
        req.url "/app_store/own/", options
      }.body
    end

    def find_all_private_for_org(org_id, options = {})
      shares_collection Podio.connection.get { |req|
        req.url "/app_store/org/#{org_id}/", options
      }.body
    end

    def find_all_recommended_for_area(area, options = {})
      list Podio.connection.get { |req|
        req.url("/app_store/recommended/#{area}/", options)
      }.body['shares']
    end

    def set_recommended_for_area(area, share_ids)
      response = Podio.connection.put do |req|
        req.url "/app_store/recommended/#{area}/"
        req.body = share_ids
      end

      response.status
    end

    def find_all_by_reference(ref_type, ref_id)
      list Podio.connection.get("/app_store/#{ref_type}/#{ref_id}/").body
    end

    def find_top(options = {})
      shares_collection Podio.connection.get { |req|
        req.url("/app_store/top/", options)
      }.body
    end

    def find_all_by_category(category_id, options = {})
      shares_collection Podio.connection.get { |req|
        req.url("/app_store/category/#{category_id}/", options)
      }.body
    end

    def find_all_by_search(options = {})
      shares_collection Podio.connection.get { |req|
        req.url("/app_store/search/", options)
      }.body
    end

    private

      def shares_collection(response)
        result = Struct.new(:all, :total_count).new(response['shares'], response['total'])
        result.all.map! { |share| new(share, :values_from_api => true) } if result.all.present?
        result
      end

  end
end

