class Podio::Status < ActivePodio::Base
  property :status_id, :integer
  property :value, :string
  property :link, :string
  property :created_on, :datetime
  property :alerts, :array
  property :ratings, :hash
  property :subscribed, :boolean
  property :user_ratings, :hash

  has_one :created_by, :class => Podio::Contact
  has_one :created_via, :class => Podio::Via
  has_many :comments, :class => Podio::Comment
  has_many :conversations, :class => Podio::Conversation
  has_many :tasks, :class => Podio::Task
  has_many :shares, :class => Podio::AppStoreShare
  has_many :files, :class => Podio::FileAttachment
  
  alias_method :id, :status_id
  alias_method :name, :value # So tasks can refer to ref.name on all types of references
end