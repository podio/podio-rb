class Podio::Filter < ActivePodio::Base
  property :filter_id, :integer
  property :name, :string
  property :created_on, :datetime
  property :items, :integer

  alias_method :id, :filter_id

  has_one :created_by, :class => 'User'

  class << self
    def find_last(app_id)
      member Podio.connection.get("/filter/app/#{app_id}/last").body
    end

    def find_all(app_id)
      list Podio.connection.get { |req|
        req.url("/filter/app/#{app_id}/")
      }.body
    end

    def delete(filter_id)
      Podio.connection.delete("/filter/#{filter_id}").status
    end
  end
end