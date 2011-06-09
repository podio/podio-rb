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
end

