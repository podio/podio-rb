class Podio::ApplicationField < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :integer
  property :config, :hash

  alias_method :id, :field_id
  delegate_to_hash :config, :label, :description, :delta, :settings, :required?, :visible?
  delegate_to_hash :settings, :allowed_values, :referenceable_types
end