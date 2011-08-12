class Podio::Activity < ActivePodio::Base
  property :id, :integer
  property :type, :string
  property :activity_type, :string
  property :data, :hash
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
end
