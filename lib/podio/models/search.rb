# @see https://developers.podio.com/doc/search
class Podio::Search < ActivePodio::Base
  property :type, :string
  property :id, :integer
  property :title, :string
  property :created_on, :datetime
  property :link, :string
  property :search_id, :integer
  property :rank, :integer

  has_one :created_by, :class => 'ByLine'
  has_one :app, :class => 'Application'
  has_one :org, :class => 'Organization'
  has_one :space, :class => 'Space'

  class << self
    # @see https://developers.podio.com/doc/search/search-in-organization-22487
    def in_org(org_id, words)
      attributes[:query] = words
      response = Podio.connection.post do |req|
        req.url "/search/org/#{org_id}/"
        req.body = attributes
      end

      list response.body
    end

    # @see https://developers.podio.com/doc/search/search-globally-22488
    def globally(words, attributes={})
      attributes[:query] = words
      response = Podio.connection.post do |req|
        req.url "/search/"
        req.body = attributes
      end

      list response.body
    end

    # @see https://developers.podio.com/doc/search/search-in-space-22479
    def in_space(space_id, words, attributes={})
      attributes[:query] = words
      response = Podio.connection.post do |req|
        req.url "/search/space/#{space_id}/"
        req.body = attributes
      end

      list response.body
    end

    # @see https://developers.podio.com/doc/search/search-in-app-4234651
    def in_app(app_id, words, attributes={})
      attributes[:query] = words
      response = Podio.connection.post do |req|
        req.url "/search/app/#{app_id}/"
        req.body = attributes
      end

      list response.body
    end

    def rank(search_id, rank)
      Podio.connection.post("/search/#{search_id}/#{rank}/clicked").status
    end
  end

end
