class Podio::Status < ActivePodio::Base
  property :status_id, :integer
  property :value, :string
  property :link, :string
  property :created_on, :datetime
  property :alerts, :array
  property :ratings, :hash
  property :subscribed, :boolean
  property :user_ratings, :hash

  has_one :created_by, :class => Contact
  has_one :created_via, :class => Via
  has_many :comments, :class => Comment
  has_many :conversations, :class => Conversation
  has_many :tasks, :class => Task
  has_many :shares, :class => AppStoreShare
  has_many :files, :class => FileAttachment
  
  alias_method :id, :status_id
  alias_method :name, :value # So tasks can refer to ref.name on all types of references
end