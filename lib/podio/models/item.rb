class Podio::Item < ActivePodio::Base

  # Included Get Item basic
  property :item_id, :integer
  property :app, :hash
  property :external_id, :string
  property :title, :string
  property :fields, :array
  property :rights, :array

  has_one :initial_revision, :class => ItemRevision
  has_one :current_revision, :class => ItemRevision
  
  # Also included in the full Get item
  property :ratings, :hash
  property :conversations, :array
  property :tasks, :array
  property :references, :array
  property :tags, :array
  property :subscribed, :boolean
  property :user_ratings, :hash

  has_many :revisions, :class => ItemRevision
  has_many :files, :class => FileAttachment
  has_many :comments, :class => Comment
  has_many :shares, :class => AppStoreShare

  # For inserting/updating
  property :file_ids, :array
  
  alias_method :id, :item_id
  delegate_to_hash :app, :app_id, :app_name, :item_name

  def destroy
    Item.delete(self.id)
  end
end