class Podio::User < ActivePodio::Base
  property :user_id, :integer
  property :mail, :string
  property :status, :string
  property :locale, :string
  property :timezone, :string
  property :flags, :array
  property :created_on, :datetime
  property :last_active_on, :datetime
  property :name, :string
  property :link, :string
  property :avatar, :integer
  property :profile_id, :integer  
  property :type, :string
  
  # Only settable on creation
  property :landing, :string
  property :referrer, :string
  property :initial, :hash
  
  alias_method :id, :user_id
end
