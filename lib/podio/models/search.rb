class Podio::Search < ActivePodio::Base
  property :type, :string
  property :id, :integer
  property :title, :string
  property :created_on, :datetime
  property :link, :string
  property :space, :hash
  property :org, :hash
  property :app, :hash
  property :search_id, :integer
  property :rank, :integer
  
  has_one :created_by, :class => 'ByLine'
  has_one :app, :class => 'Application'

  class << self
    def in_org(org_id, words)
      response = Podio.connection.post do |req|
        req.url "/search/org/#{org_id}/"
        req.body = words
      end

      list response.body
    end

    def globally(words, attributes={})
      attributes[:query] = words
      response = Podio.connection.post do |req|
        req.url "/search/"
        req.body = attributes
      end

      list response.body
    end

    def in_space(space_id, words, attributes={})
      attributes[:query] = words
      response = Podio.connection.post do |req|
        req.url "/search/space/#{space_id}/"
        req.body = attributes
      end

      list response.body
    end

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