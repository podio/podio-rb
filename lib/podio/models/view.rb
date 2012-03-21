class Podio::View < ActivePodio::Base
  property :view_id, :integer
  property :name, :string
  property :created_on, :datetime
  property :items, :integer
  property :sort_by, :string
  property :sort_desc, :string
  property :filters, :hash
  property :layout, :string
  property :fields, :hash

  alias_method :id, :view_id

  has_one :created_by, :class => 'User'

  class << self
    def find_last(app_id)
      member Podio.connection.get("/view/app/#{app_id}/last").body
    end

    def find_all(app_id)
      list Podio.connection.get { |req|
        req.url("/view/app/#{app_id}/")
      }.body
    end

    def find(id)
      member Podio.connection.get("/view/#{id}").body
    end

    def delete(view_id)
      Podio.connection.delete("/view/#{view_id}").status
    end

    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/view/app/#{app_id}/"
        req.body = attributes
      end

      response.body['view_id']
    end
  end
end