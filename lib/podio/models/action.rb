class Podio::Action < ActivePodio::Base
  property :action_id, :integer
  property :type, :string
  property :data, :hash

  alias_method :id, :action_id
end
