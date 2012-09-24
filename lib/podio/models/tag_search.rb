# @see https://developers.podio.com/doc/tags
class Podio::TagSearch < ActivePodio::Base
  property :id, :integer
  property :type, :string
  property :title, :string
  property :link, :string
  property :created_on, :datetime

  class << self
    def search_by_space(space_id, text)
      text = CGI.escape(text) if text
      list Podio.connection.get("/tag/space/#{space_id}/search/?text=#{text}").body
    end
  end
end
