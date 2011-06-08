# Wraps common via hashes.
class Podio::Via < ActivePodio::Base
  property :id, :integer
  property :name, :string
  property :url, :string
  property :display, :boolean
end