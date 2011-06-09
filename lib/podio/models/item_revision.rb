class Podio::ItemRevision < ActivePodio::Base
  property :revision, :integer
  property :app_revision, :integer
  property :created_on, :datetime

  has_one :created_by, :class => Podio::ByLine
  has_one :created_via, :class => Podio::Via
end