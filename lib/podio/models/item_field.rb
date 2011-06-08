class Podio::ItemField < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :integer
  property :label, :string
  property :values, :array

  alias_method :id, :field_id
end