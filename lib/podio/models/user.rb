class Podio::User < ActivePodio::Base
  property :user_id, :integer
  property :mail, :string
  property :status, :string
  property :locale, :string
  property :timezone, :string
  property :password, :string
  property :old_password, :string
  property :new_password, :string
  property :flags, :array
  property :betas, :array
  property :created_on, :datetime
  property :name, :string
  property :link, :string
  property :avatar, :integer
  property :profile_id, :integer
  property :type, :string

  has_many :mails, :class => 'UserMail'
  has_one :profile, :class => 'Contact'

  # Only settable on creation
  property :landing, :string
  property :referrer, :string
  property :internal, :hash
  property :marketo_cookie, :string

  alias_method :id, :user_id

  class << self
    def current
      member Podio.connection.get("/user/").body
    end

    def create(attributes)
      response = Podio.client.trusted_connection.post do |req|
        req.url '/user/'
        req.body = attributes
      end

      response.body['user_id']
    end

    def create_inactive(attributes)
      response = Podio.connection.post do |req|
        req.url '/user/inactive/'
        req.body = attributes
      end

      response.body['user_id']
    end

    def update(attributes)
      Podio.connection.put("/user/", attributes).status
    end

    def update_profile(attributes)
      Podio.connection.put("/user/profile/", attributes).status
    end

    def activate(attributes)
      response = Podio.connection.post do |req|
        req.url '/user/activate_user'
        req.body = attributes
      end

      member response.body
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

    def get_property_hash(name)
      Podio.connection.get("/user/property/#{name}").body
    end

    def set_property_hash(name, hash)
      Podio.connection.put("/user/property/#{name}", hash).status
    end

    def set_properties(attributes)
      response = Podio.connection.put do |req|
        req.url '/user/property/'
        req.body = attributes
      end

      response.body
    end

    def remove_property(name)
      Podio.connection.delete("/user/property/#{name}", {}).status
    end

    def mail_verification(attributes)
      response = Podio.connection.post do |req|
        req.url '/user/mail_verification/'
        req.body = attributes
      end

      response.body
    end

    def verify(verification_code)
      Podio.connection.post("/user/mail_verification/#{verification_code}").status
    end

    def recover(mail)
      response = Podio.connection.post do |req|
        req.url '/user/recover_password'
        req.body = {:mail => mail}
      end

      response.status
    end

    def reset(password, recovery_code)
      response = Podio.connection.post do |req|
        req.url '/user/reset_password'
        req.body = {:password => password, :recovery_code => recovery_code}
      end

      response.body
    end

    def delete
      Podio.connection.delete("/user/").status
    end

    def internal_source
      Podio.connection.get("/user/source").body
    end
  end
end
