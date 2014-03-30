class Podio::Voting < ActivePodio::Base

  property :voting_id, :integer
  property :kind, :string
  property :question, :string
  
  alias_method :id, :voting_id

end
