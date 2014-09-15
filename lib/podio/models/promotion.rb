class Podio::Promotion < ActivePodio::Base
  property :promotion_id, :integer
  property :name, :string
  property :status, :string
  property :display_type, :string
  property :display_data, :hash
  property :context, :string
  property :priority, :integer
  property :max_views, :integer
  property :max_duration, :boolean
  property :end_on_use, :boolean
  property :sleep, :integer
  property :condition_set_ids, :array

  has_many :condition_sets, :class => 'ConditionSet'

  alias_method :id, :promotion_id

  class << self
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/promotion/", options)
      }.body
    end

    def find(promotion_id)
      member Podio.connection.get("/promotion/#{promotion_id}").body
    end

    def create(attributes)
      member Podio.connection.post { |req|
        req.url("/promotion/")
        req.body = attributes
      }.body
    end

    def update(promotion_id, attributes)
      member Podio.connection.put { |req|
        req.url("/promotion/#{promotion_id}")
        req.body = attributes
      }.body
    end

    def enable(promotion_id)
      member Podio.connection.post("/promotion/#{promotion_id}/enable").body
    end

    def disable(promotion_id)
      member Podio.connection.post("/promotion/#{promotion_id}/disable").body
    end

    def delete(promotion_id)
      Podio.connection.delete("/promotion/#{promotion_id}")
    end

    def stats(promotion_id)
      Podio.connection.get("/promotion/#{promotion_id}/stats").body
    end

    def assign(promotion_id, user_id)
      Podio.connection.post("/promotion/#{promotion_id}/assign/#{user_id}")
    end

    def find_for_context(context_name, options = {})
      result = Podio.connection.get("/promotion/#{context_name}", options)

      if result.body.present?
        member(result.body)
      else
        nil
      end
    end

    def end(promotion_id, body = nil)
      Podio.connection.post { |req|
        req.url "/promotion/#{promotion_id}/end"
        req.body = body
      }
    end

    def click(promotion_id, body = nil)
      Podio.connection.post { |req|
        req.url "/promotion/#{promotion_id}/click"
        req.body = body
      }
    end
  end

end
