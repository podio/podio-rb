class Podio::ConditionSet < ActivePodio::Base
  property :condition_set_id, :integer
  property :name, :string
  property :description, :string

  has_many :conditions, :class => 'Condition'

  alias_method :id, :condition_set_id

  class << self
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/condition_set/", options)
      }.body
    end

    def find(condition_set_id)
      member Podio.connection.get("/condition_set/#{condition_set_id}").body
    end

    def create(attributes)
      member Podio.connection.post { |req|
        req.url("/condition_set/")
        req.body = attributes
      }.body
    end

    def update(condition_set_id, attributes)
      member Podio.connection.put { |req|
        req.url("/condition_set/#{condition_set_id}")
        req.body = attributes
      }.body
    end

    def delete(condition_set_id)
      Podio.connection.delete("/condition_set/#{condition_set_id}")
    end
  end

end
