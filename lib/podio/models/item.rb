# @see https://developers.podio.com/doc/items
class Podio::Item < ActivePodio::Base
  include ActivePodio::Updatable

  # Included Get Item basic
  property :item_id, :integer
  property :app, :hash
  property :external_id, :string
  property :title, :string
  property :fields, :array
  property :rights, :array
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_one :date_election, :class => 'DateElection'

  # Also included in the full Get item
  property :ratings, :hash
  property :conversations, :array
  property :tasks, :array
  property :references, :array
  property :refs, :array
  property :tags, :array
  property :subscribed, :boolean
  property :pinned, :boolean
  property :user_ratings, :hash
  property :link, :string
  property :invite, :hash
  property :participants, :hash
  property :linked_account_id, :integer
  property :ref, :hash  # linked items
  property :priority, :float
  property :excerpt, :string
  property :is_liked, :boolean
  property :like_count, :integer
  property :push, :hash
  property :presence, :hash

  # Get items
  property :comment_count, :integer
  property :task_count, :integer
  property :subscribed_count, :integer

  has_many :revisions, :class => 'ItemRevision'
  has_many :files, :class => 'FileAttachment'
  has_many :comments, :class => 'Comment'
  has_many :shares, :class => 'AppStoreShare'
  has_one :reminder, :class => 'Reminder'
  has_one :recurrence, :class => 'Recurrence'
  has_one :linked_account_data, :class => 'LinkedAccountData'
  has_one :application, :class => 'Application', :property => :app

  # For inserting/updating
  property :file_ids, :array

  alias_method :id, :item_id
  delegate_to_hash :app, :app_id, :app_name, :item_name

  # @see https://developers.podio.com/doc/items/add-new-item-22362
  def create
    self.item_id = self.class.create(self.app_id, prepare_item_values(self))
  end

  # @see https://developers.podio.com/doc/items/delete-item-22364
  def destroy
    self.class.delete(self.id)
  end

  # @see https://developers.podio.com/doc/items/update-item-22363
  def update
    self.class.update(self.id, prepare_item_values(self))
  end

  protected
      def prepare_item_values(item)
        fields = item.fields.collect { |field| field.values.nil? ? nil : { :external_id => field.external_id, :values => field.values } }.compact
        file_ids = item[:file_ids]
        tags = item.tags.collect(&:presence).compact

        {:fields => fields, :file_ids => file_ids, :tags => tags }
      end

  class << self
    # @see https://developers.podio.com/doc/items/get-item-22360
    def find(id)
      member Podio.connection.get("/item/#{id}").body
    end

    # @see https://developers.podio.com/doc/items/get-item-basic-61768
    def find_basic(id, options={})
      member Podio.connection.get { |req|
        req.url("/item/#{id}/basic", options)
      }.body
    end

    def find_basic_hash(id)
      Podio.connection.get("/item/#{id}/basic").body
    end

    def find_basic_by_field(item_id, field_id)
      member Podio.connection.get("/item/#{item_id}/reference/#{field_id}/preview").body
    end

    def find_basic_hash_by_field(item_id, field_id)
      Podio.connection.get("/item/#{item_id}/reference/#{field_id}/preview").body
    end

    def find_all_by_external_id(app_id, external_id)
      collection Podio.connection.get("/item/app/#{app_id}/v2/?external_id=#{external_id}").body
    end

    # @see https://developers.podio.com/doc/items/get-items-27803
    def find_all(app_id, options={})
      collection Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/items/filter-items-by-view-4540284
    def find_by_filter_id(app_id, filter_id, attributes)
      collection Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/filter/#{filter_id}/"
        req.body = attributes
      }.body
    end

    # @see https://developers.podio.com/doc/items/filter-items-4496747
    def find_by_filter_values(app_id, filter_values, attributes={})
      attributes[:filters] = filter_values
      collection Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/filter/"
        req.body = attributes
      }.body
    end

    # @see https://developers.podio.com/doc/items/get-app-values-22455
    def find_app_values(app_id)
      response = Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/values")
      }
      response.body
    end

    def find_references_by_field(item_id, field_id, options = {})
      list Podio.connection.get { |req|
        req.url("/item/#{item_id}/reference/field/#{field_id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/items/calculate-67633
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

    # @see https://developers.podio.com/doc/items/get-items-as-xlsx-63233
    def xlsx(app_id, options={})
      response = Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/xlsx/", options)
      }
      response.body
    end

    # @see https://developers.podio.com/doc/items/export-items-4235696
    def export(app_id, exporter, options={})
      response = Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/export/#{exporter}"
        req.body = options
      }.body
    end

    # @see https://developers.podio.com/doc/items/find-items-by-field-and-title-22485
    def search_field(field_id, options={})
      list Podio.connection.get { |req|
        req.url("/item/field/#{field_id}/find", options)
      }.body
    end

    # @see https://developers.podio.com/doc/items/add-new-item-22362
    def create(app_id, attributes, options={})
      response = Podio.connection.post do |req|
        req.url("/item/app/#{app_id}/", options)
        req.body = attributes
      end

      response.body['item_id']
    end

    # @see https://developers.podio.com/doc/items/update-item-22363
    def update(id, attributes, options={})
      response = Podio.connection.put do |req|
        req.url("/item/#{id}", options)
        req.body = attributes
      end
      response.status
    end

    # @see https://developers.podio.com/doc/items/bulk-delete-items-19406111
    def bulk_delete(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url("/item/app/#{app_id}/delete")
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/items/delete-item-22364
    def delete(id)
      Podio.connection.delete("/item/#{id}").body
    end

    # @see https://developers.podio.com/doc/items/delete-item-reference-7302326
    def delete_ref(id)
      Podio.connection.delete("/item/#{id}/ref").body
    end

    # @see https://developers.podio.com/doc/items/clone-item-37722742
    def clone(item_id, options={})
      response = Podio.connection.post do |req|
        req.url("/item/#{item_id}/clone", options)
      end

      response.body['item_id']
    end

    # @see https://developers.podio.com/doc/items/set-participation-7156154
    def set_participation(id, status)
      response = Podio.connection.put do |req|
        req.url "/item/#{id}/participation"
        req.body = { :status => status }
      end
      response.status
    end

    def cleanup_field_values(app_id)
      Podio.connection.post("/item/app/#{app_id}/cleanup_field_values").body
    end

    def rearrange(id, attributes)
      response = Podio.connection.post do |req|
        req.url "/item/#{id}/rearrange"
        req.body = attributes
      end

      member response.body
    end

    # @see https://developers.podio.com/doc/items/get-meeting-url-14763260
    def find_meeting_url(id)
      response = Podio.connection.get { |req|
        req.url("/item/#{id}/meeting/url")
      }
      response.body
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
