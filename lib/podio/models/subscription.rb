class Podio::Subscription < ActivePodio::Base
  property :started_on, :datetime
  property :notifications, :integer
  property :ref, :hash
end