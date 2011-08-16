class Podio::Filter < ActivePodio::Base
  property :sort_by, :string
  property :sort_desc, :boolean
  property :filters, :array

  class << self
    def find_last(app_id)
      member Podio.connection.get("/filter/app/#{app_id}/last").body
    end
  end
end