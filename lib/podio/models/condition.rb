class Podio::Condition < ActivePodio::Base
  property :condition_id, :integer
  property :type, :string
  property :config, :hash
  property :negate, :boolean

  alias_method :id, :condition_id
end
