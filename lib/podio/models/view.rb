# @see https://developers.podio.com/doc/filters
class Podio::View < ActivePodio::Base
  property :view_id, :string
  property :name, :string
  property :created_on, :datetime
  property :items, :integer
  property :sort_by, :string
  property :sort_desc, :string
  property :filters, :hash
  property :layout, :string
  property :fields, :hash
  property :type, :string

  alias_method :id, :view_id

  has_one :created_by, :class => 'User'

  class << self
    # @see https://developers.podio.com/doc/views/get-last-view-27663
    def find_last(app_id)
      member Podio.connection.get("/view/app/#{app_id}/last").body
    end

    # @see https://developers.podio.com/doc/views/get-views-27460
    def find_all(app_id, options={})
      list Podio.connection.get { |req|
        req.url("/view/app/#{app_id}/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/views/get-view-27450
    def find(id, app_id=nil)
      path = app_id ? "/view/app/#{app_id}/#{id}" : "/view/#{id}"

      member Podio.connection.get(path).body
    end

    # @see https://developers.podio.com/doc/views/delete-view-27454
    def delete(view_id)
      Podio.connection.delete("/view/#{view_id}").status
    end

    # @see https://developers.podio.com/doc/views/create-view-27453
    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/view/app/#{app_id}/"
        req.body = attributes
      end

      member response.body
    end

    # @see https://developers.podio.com/doc/views/update-view-20069949
    def update(view_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/view/#{view_id}"
        req.body = attributes
      end

      response.status
    end

    # @see https://developers.podio.com/doc/views/update-last-view-5988251
    def update_last(app_id, attributes)
      Podio.connection.put do |req|
        req.url "/view/app/#{app_id}/last"
        req.body = attributes
      end
    end

    # @see https://developers.podio.com/doc/views/make-default-155388326
    def make_default(view_id)
      Podio.connection.post("/view/#{view_id}/default").status
    end
  end
end
