# @see https://developers.podio.com/doc/applications
class Podio::Application < ActivePodio::Base
  property :app_id, :integer
  property :original, :integer
  property :original_revision, :integer
  property :status, :string
  property :icon, :string
  property :icon_id, :integer
  property :space_id, :integer
  property :owner_id, :integer
  property :owner, :hash
  property :config, :hash
  property :fields, :array
  property :subscribed, :boolean
  property :integration, :hash
  property :rights, :array
  property :link, :string
  property :url_add, :string
  property :token, :string
  property :url_label, :string
  property :mailbox, :string

  # When app is returned as part of large collection (e.g. for stream), some config properties is moved to the main object
  property :name, :string
  property :item_name, :string

  has_one :integration, :class => 'Integration'

  alias_method :id, :app_id
  delegate_to_hash :config, :allow_edit?, :allow_attachments?, :allow_comments?, :description, :visible?, :usage, :default_view

  def name
    self[:name] || self.config['name']
  end

  def item_name
    self[:item_name] || self.config['item_name']
  end

  class << self
    # @see https://developers.podio.com/doc/applications/get-app-22349
    def find(app_id, options = {})
      member Podio.connection.get { |req|
        req.url("/app/#{app_id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/applications/get-app-on-space-by-url-label-477105
    def find_by_url_label(space_id, url_label)
      member Podio.connection.get("/app/space/#{space_id}/#{url_label}").body
    end

    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/app/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/applications/get-all-user-apps-5902728
    def find_all_for_current_user(options={})
      list Podio.connection.get { |req|
        req.url("/app/v2/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/applications/get-top-apps-22476
    def find_top(options={})
      list Podio.connection.get { |req|
        req.url("/app/top/", options)
      }.body
    end

    ## @see https://developers.podio.com/doc/applications/get-top-apps-for-organization-1671395
    def find_top_for_org(org_id, options={})
      list Podio.connection.get { |req|
        req.url("/app/org/#{org_id}/top/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/applications/get-apps-by-space-22478
    def find_all_for_space(space_id, options = {})
      list Podio.connection.get { |req|
        req.url("/app/space/#{space_id}/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/applications/get-calculations-for-app-773005
    def get_calculations(app_id)
      list Podio.connection.get { |req|
        req.url("/app/#{app_id}/calculation/", {})
      }.body
    end

    # @see https://developers.podio.com/doc/applications/update-app-order-22463
    def update_order(space_id, app_ids = [])
      response = Podio.connection.put do |req|
        req.url "/app/space/#{space_id}/order"
        req.body = app_ids
      end

      response.body
    end

    # @see https://developers.podio.com/doc/applications/add-new-app-22351
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app/"
        req.body = attributes
      end
      response.body['app_id']
    end

    # @see https://developers.podio.com/doc/applications/update-app-22352
    def update(app_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/app/#{app_id}"
        req.body = attributes
      end
      response.status
    end

    # @see https://developers.podio.com/doc/applications/update-app-description-33569973
    def update_description(app_id, description)
      response = Podio.connection.put do |req|
        req.url "/app/#{app_id}/description"
        req.body = {:description => description}
      end
      response.status
    end

    # @see https://developers.podio.com/doc/applications/update-app-usage-33570086
    def update_usage(app_id, usage)
      response = Podio.connection.put do |req|
        req.url "/app/#{app_id}/usage"
        req.body = {:usage => usage}
      end
      response.status
    end

    # @see https://developers.podio.com/doc/applications/install-app-22506
    def install(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/app/#{app_id}/install"
        req.body = attributes
      end
      response.body['app_id']
    end

    # @see https://developers.podio.com/doc/applications/delete-app-field-22355
    def delete_field(app_id, field_id)
      Podio.connection.delete("/app/#{app_id}/field/#{field_id}").status
    end

    # @see https://developers.podio.com/doc/applications/deactivate-app-43821
    def deactivate(id)
      Podio.connection.post("/app/#{id}/deactivate").body
    end

    # @see https://developers.podio.com/doc/applications/activate-app-43822
    def activate(id)
      Podio.connection.post("/app/#{id}/activate").body
    end

    # @see https://developers.podio.com/doc/applications/delete-app-43693
    def delete(id)
      Podio.connection.delete("/app/#{id}").body
    end

    def install_on_mobile(id)
      Podio.connection.post("/mobile/install_app/#{id}").body
    end

    # @see https://developers.podio.com/doc/applications/get-features-43648
    def features(options)
      Podio.connection.get { |req|
        req.url("/app/features/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/applications/get-app-dependencies-39159
    def dependencies(id)
      Podio.connection.get("/app/#{id}/dependencies/").body
    end

    # @see https://developers.podio.com/doc/applications/get-space-app-dependencies-45779
    def space_dependencies(space_id)
      result = Podio.connection.get("/app/space/#{space_id}/dependencies/").body
      result['apps'] = result['apps'].collect { |app| Application.new(app) }
      result
    end

  end
end
