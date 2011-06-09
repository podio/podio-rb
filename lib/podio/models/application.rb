class Podio::Application < ActivePodio::Base
  property :app_id, :integer
  property :original, :integer
  property :original_revision, :integer
  property :status, :string
  property :icon, :string
  property :space_id, :integer
  property :owner_id, :integer
  property :owner, :hash
  property :config, :hash
  property :fields, :array
  property :subscribed, :boolean
  property :integration, :hash
  property :rights, :array
  property :link, :string
  
  has_one :integration, :class => 'Integration'

  alias_method :id, :app_id
  delegate_to_hash :config, :name, :item_name, :allow_edit?, :allow_attachments?, :allow_comments?, :description
  
  class << self
    def find(app_id)
      member Podio.connection.get("/app/#{app_id}").body
    end
    
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/app/", options)
      }.body
    end

    def find_all_for_space(space_id, options = {})
      list Podio.connection.get { |req|
        req.url("/app/space/#{space_id}/", options)
      }.body
    end

    def update_order(space_id, app_ids = [])
      response = Podio.connection.put do |req|
        req.url "/app/space/#{space_id}/order"
        req.body = app_ids
      end

      response.body
    end
    
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app/"
        req.body = attributes
      end
      response.body['app_id']
    end
    
    def deactivate(id)
      Podio.connection.post("/app/#{id}/deactivate").body
    end
    
    def delete(id)
      Podio.connection.delete("/app/#{id}").body
    end
  end
end