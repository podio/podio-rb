class Podio::SpaceInvitation < ActivePodio::Base
  include ActivePodio::Updatable

  property :space_id, :integer
  property :role, :string
  property :subject, :string
  property :message, :string
  property :notify, :boolean
  property :users, :array
  property :mails, :array
  property :profiles, :array
  property :activation_code, :integer
  property :context_ref_type, :string # Write
  property :context_ref_id, :integer # Write
  property :context, :hash # Read
  property :external_contacts, :hash

  has_one :user, :class => 'User'

  def save
    self.class.create(self.space_id, self.role, self.attributes.except(:contacts))
  end

  def save_member
    self.class.create_member(self.space_id, self.role, self.attributes.except(:contacts))
  end

  def accept(invite_code)
    self.class.accept(invite_code)
  end

  class << self
    def create(space_id, role, attributes={})
      response = Podio.connection.post do |req|
        req.url "/space/#{space_id}/invite"
        req.body = attributes.merge(:role => role)
      end

      response.body
    end

    def create_member(space_id, role, attributes={})
      response = Podio.connection.post do |req|
        req.url "/space/#{space_id}/member/"
        req.body = attributes.merge(:role => role)
      end

      response.body
    end

    def accept(invite_code)
      response = Podio.connection.post do |req|
        req.url '/space/invite/accept'
        req.body = {:invite_code => invite_code}
      end

      response.body
    end

    def decline(invite_code)
      response = Podio.connection.post do |req|
        req.url '/space/invite/decline'
        req.body = {:invite_code => invite_code}
      end

      response.body
    end

    def find_member(invite_code)
      member Podio.client.trusted_connection.get("/space/membership?invite_code=#{invite_code}").body
    end

    def decline_member(invite_code)
      Podio.client.trusted_connection.delete("/space/membership?invite_code=#{invite_code}").status
    end

    def claim_member(invite_code)
      Podio.connection.post("/space/membership/claim?invite_code=#{invite_code}").body
    end
  end
end
