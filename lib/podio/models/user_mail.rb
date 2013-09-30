# @see https://developers.podio.com/doc/users
class Podio::UserMail < ActivePodio::Base
  property :mail, :string
  property :verified, :boolean
  property :primary, :boolean
  property :disabled, :boolean

  def self.validate(mail)
    Podio.client.trusted_connection.post("/user/mail_validation", :mail => mail).body
  end
end
