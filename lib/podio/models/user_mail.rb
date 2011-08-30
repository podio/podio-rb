class Podio::UserMail < ActivePodio::Base
  property :mail, :string
  property :verified, :boolean
  property :primary, :boolean
  property :disabled, :boolean

end
