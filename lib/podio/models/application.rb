class Podio::Application < ActivePodio::Base
  property :app_id, :integer
  property :original, :integer
  property :original_revision, :integer
  property :status, :string
  property :icon, :string
  property :space_id, :integer
  property :owner_id, :integer
  property :owner, :hash
  property :config, :hash
  property :fields, :array
  property :subscribed, :boolean
  property :integration, :hash
  property :rights, :array
  property :link, :string
  
  has_one :integration, :class => Integration

  alias_method :id, :app_id
  delegate_to_hash :config, :name, :item_name, :allow_edit?, :allow_attachments?, :allow_comments?, :description
end