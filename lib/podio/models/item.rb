class Podio::Item < ActivePodio::Base
  include ActivePodio::Updatable

  # Included Get Item basic
  property :item_id, :integer
  property :app, :hash
  property :external_id, :string
  property :title, :string
  property :fields, :array
  property :rights, :array

  has_one :initial_revision, :class => 'ItemRevision'
  has_one :current_revision, :class => 'ItemRevision'

  # Also included in the full Get item
  property :ratings, :hash
  property :conversations, :array
  property :tasks, :array
  property :references, :array
  property :refs, :array
  property :tags, :array
  property :subscribed, :boolean
  property :user_ratings, :hash
  property :link, :string
  property :invite, :hash
  property :participants, :hash
  property :linked_account_id, :integer

  # Get items
  property :comment_count, :integer

  has_many :revisions, :class => 'ItemRevision'
  has_many :files, :class => 'FileAttachment'
  has_many :comments, :class => 'Comment'
  has_many :shares, :class => 'AppStoreShare'
  has_one :reminder, :class => 'Reminder'
  has_one :recurrence, :class => 'Recurrence'

  # For inserting/updating
  property :file_ids, :array

  alias_method :id, :item_id
  delegate_to_hash :app, :app_id, :app_name, :item_name

  def create
    self.item_id = Item.create(self.app_id, prepare_item_values(self))
  end

  def destroy
    Item.delete(self.id)
  end

  def update
    Item.update(self.id, prepare_item_values(self))
  end

  handle_api_errors_for :create, :update

  protected
      def prepare_item_values(item)
        fields = item.fields.collect { |field| field.values.nil? ? nil : { :external_id => field.external_id, :values => field.values } }.compact
        file_ids = item[:file_ids]
        tags = item.tags.collect(&:presence).compact

        {:fields => fields, :file_ids => file_ids, :tags => tags }
      end

  class << self
    def find(id)
      member Podio.connection.get("/item/#{id}").body
    end

    def find_basic(id)
      member Podio.connection.get("/item/#{id}/basic").body
    end

    def find_basic_hash(id)
      Podio.connection.get("/item/#{id}/basic").body
    end

    def find_all_by_external_id(app_id, external_id)
      collection Podio.connection.get("/item/app/#{app_id}/v2/?external_id=#{external_id}").body
    end

    def find_all(app_id, options={})
      collection Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/", options)
      }.body
    end

    def find_by_filter_id(app_id, filter_id, attributes)
      collection Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/filter/#{filter_id}/"
        req.body = attributes
      }.body
    end

    def find_by_filter_values(app_id, filter_values, attributes={})
      attributes[:filters] = filter_values
      collection Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/filter/"
        req.body = attributes
      }.body
    end

    def find_next(current_item_id, time = nil)
      find_next_or_previous(:next, current_item_id, time)
    end

    def find_previous(current_item_id, time = nil)
      find_next_or_previous(:previous, current_item_id, time)
    end

    def find_app_values(app_id)
      response = Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/values")
      }
      response.body
    end

    def calculate(app_id, config)
      response = Podio.connection.post do |req|
        req.url "/item/app/#{app_id}/calculate"
        req.body = config
      end

      response.body
    end

    def find_field_top(field_id, options={:limit => 8})
      list Podio.connection.get { |req|
        req.url("/item/field/#{field_id}/top/", options)
      }.body
    end

    def xlsx(app_id, options={})
      response = Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/xlsx/", options)
      }
      response.body
    end

    def export(app_id, exporter, options={})
      response = Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/export/#{exporter}"
        req.body = options
      }.body
    end

    def search_field(field_id, options={})
      list Podio.connection.get { |req|
        req.url("/item/field/#{field_id}/find", options)
      }.body
    end

    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/item/app/#{app_id}/"
        req.body = attributes
      end

      response.body['item_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/item/#{id}"
        req.body = attributes
      end
      response.status
    end

    def delete(id)
      Podio.connection.delete("/item/#{id}").body
    end

    def set_participation(id, status)
      response = Podio.connection.put do |req|
        req.url "/item/#{id}/participation"
        req.body = { :status => status }
      end
      response.status
    end

    protected

      def time_options(time)
        time.present? ? { 'time' => (time.is_a?(String) ? time : time.to_s(:db)) } : {}
      end

      def find_next_or_previous(operation, current_item_id, time)
        member Podio.connection.get { |req|
          req.url("/item/#{current_item_id}/#{operation}", time_options(time))
        }.body
      end
  end
end
