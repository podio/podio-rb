class Podio::Bulletin < ActivePodio::Base
  property :bulletin_id, :integer
  property :title, :string
  property :summary, :string
  property :text, :string
  property :locale, :string
  property :target_group, :string
  property :created_on, :datetime

  has_one :created_by, :class => ByLine

  alias_method :id, :bulletin_id
end
