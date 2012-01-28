class Podio::Filter < ActivePodio::Base
  property :filter_id, :integer
  property :name, :string
  property :created_on, :datetime
  property :items, :integer
  property :sort_by, :string
  property :sort_desc, :string
  property :filters, :hash

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

    def find(id)
      member Podio.connection.get("/filter/#{id}").body
    end

    def delete(filter_id)
      Podio.connection.delete("/filter/#{filter_id}").status
    end

    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/filter/app/#{app_id}/"
        req.body = attributes
      end

      response.body['filter_id']
    end
  end
end