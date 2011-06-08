class Podio::ItemDiff < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :integer
  property :label, :string
  property :from, :array
  property :to, :array
end