class Podio::User < ActivePodio::Base
  property :user_id, :integer
  property :mail, :string
  property :status, :string
  property :locale, :string
  property :timezone, :string
  property :flags, :array
  property :created_on, :datetime
  property :last_active_on, :datetime
  property :name, :string
  property :link, :string
  property :avatar, :integer
  property :profile_id, :integer  
  property :type, :string
  
  # Only settable on creation
  property :landing, :string
  property :referrer, :string
  property :initial, :hash
  
  alias_method :id, :user_id
  
  class << self
    def current
      member Podio.connection.get("/user/").body
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/user/'
        req.body = attributes
      end

      response.body['user_id']
    end

    def activate(attributes)
      response = Podio.connection.post do |req|
        req.url '/user/activate_user'
        req.body = attributes
      end

      response.body['user_id']
    end

    def find_all_admins_for_org(org_id)
      list Podio.connection.get("/org/#{org_id}/admin/").body
    end

    def get_property(name)
      Podio.connection.get("/user/property/#{name}").body['value']
    end
    
    def set_property(name, value)
      Podio.connection.put("/user/property/#{name}", {:value => value}).status
    end

    def remove_property(name)
      Podio.connection.delete("/user/property/#{name}", {}).status
    end
  end
end
