class Podio::Item < ActivePodio::Base

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
  property :tags, :array
  property :subscribed, :boolean
  property :user_ratings, :hash

  has_many :revisions, :class => 'ItemRevision'
  has_many :files, :class => 'FileAttachment'
  has_many :comments, :class => 'Comment'
  has_many :shares, :class => 'AppStoreShare'

  # For inserting/updating
  property :file_ids, :array
  
  alias_method :id, :item_id
  delegate_to_hash :app, :app_id, :app_name, :item_name

  def destroy
    Item.delete(self.id)
  end
  
  class << self
    def find(id)
      member Podio.connection.get("/item/#{id}").body
    end

    def find_basic(id)
      member Podio.connection.get("/item/#{id}/basic").body
    end

    def find_all_by_external_id(app_id, external_id)
      collection Podio.connection.get("/item/app/#{app_id}/v2/?external_id=#{external_id}").body
    end

    def find_all(app_id, options={})
      collection Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/", options)
      }.body
    end
    
    def find_next(current_item_id, time = nil)
      find_next_or_previous(:next, current_item_id, time)
    end

    def find_previous(current_item_id, time = nil)
      find_next_or_previous(:previous, current_item_id, time)
    end
    
    def find_field_top(field_id, options={:limit => 8})
      list Podio.connection.get { |req|
        req.url("/item/field/#{field_id}/top/", options)
      }.body
    end

    def search_field(field_id, options={})
      list Podio.connection.get { |req|
        req.url("/item/field/#{field_id}/find", options)
      }.body
    end

    # Deprecated. Use method in ItemRevision instead.
    # def revisions(item_id)
    #   collection Podio.connection.get("/item/#{item_id}/revision/").body
    # end

    # Deprecated. Use method in ItemDiff instead.
    # def revision_difference(item_id, revision_from_id, revision_to_id)
    #   list Podio.connection.get{ |req|
    #     req.url("/item/#{item_id}/revision/#{revision_from_id}/#{revision_to_id}")
    #   }.body
    # end

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