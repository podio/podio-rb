class Podio::SpaceInvite < ActivePodio::Base
  property :space_id, :integer
  property :role, :string
  property :subject, :string
  property :message, :string
  property :notify, :boolean
  property :users, :array
  property :mails, :array
  property :profiles, :array
  property :activation_code, :integer

  def save
    self.class.create(self.space_id, self.role, self.attributes.except(:contacts))
  end

  def accept(invite_code)
    self.class.accept(invite_code)
  end
  
  handle_api_errors_for :save, :accept # Call must be made after the methods to handle have been defined
end
