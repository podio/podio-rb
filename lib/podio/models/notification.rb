class Podio::Notification < ActivePodio::Base
  property :notification_id, :integer
  property :user, :hash
  property :type, :string
  property :viewed_on, :datetime
  property :subscription_id, :integer
  property :created_on, :datetime
  property :data, :hash
  property :starred, :boolean

  # Only available when getting a single notification
  property :space, :hash
  property :org, :hash
  property :data_link, :string
  property :context_type, :string
  property :context_link, :string
  property :context, :hash

  has_one :created_by, :class => Podio::ByLine
  has_one :created_via, :class => Podio::Via
  has_one :user, :class => Podio::User

  alias_method :id, :notification_id
  delegate_to_hash :data, :field, :value, :role, :message
end
