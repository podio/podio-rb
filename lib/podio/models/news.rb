class Podio::News < ActivePodio::Base
  property :news_id, :integer
  property :title, :string
  property :content, :string
  property :link, :string

  alias_method :id, :news_id
end