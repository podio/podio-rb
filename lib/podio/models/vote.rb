class Podio::Vote < ActivePodio::Base

  property :rating, :integer
  
  has_one :answer, :class => 'Answer'
  has_one :voting, :class => 'Voting'

end
