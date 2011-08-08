class Podio::UserMail < ActivePodio::Base
  property :mail, :string
  property :verified, :boolean
  property :primary, :boolean
  property :verified_on, :datetime

  class << self

  end
end