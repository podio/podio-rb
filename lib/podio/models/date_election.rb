class Podio::DateElection < ActivePodio::Base

  property :date_election_id, :integer
  property :votes, :array
  property :options, :array

end