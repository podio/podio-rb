# Wraps common byline hashes. See https://hoist.podio.com/api/item/56084
class Podio::ByLine < ActivePodio::Base
  property :type, :string
  property :id, :integer
  property :avatar_type, :string
  property :avatar_id, :integer
  property :image, :hash
  property :name, :string
  property :url, :string
  property :avatar, :integer # Sometimes used by older operations
end