class Podio::DateElectionVote < ActivePodio::Base
  property :date_option_id, :integer
  property :value, :boolean

  has_one :user, :class => 'Contact'
end

class Podio::DateElectionOption < ActivePodio::Base
  property :date_option_id, :integer
  property :start_utc, :datetime
  property :end_utc, :datetime
end

class Podio::DateElection < ActivePodio::Base
  property :date_election_id, :integer

  has_many :votes, :class => 'DateElectionVote'
  has_many :options, :class => 'DateElectionOption'

  class << self
    def vote(date_election_id, date_option_id, value)
      Podio.connection.post do |req|
        req.url "/date_election/#{date_election_id}/vote"
        req.body = {:date_option_id => date_option_id.to_i, :value => value}
      end
    end

    def choose(date_election_id, date_option_id)
      Podio.connection.post do |req|
        req.url "/date_election/#{date_election_id}/choose"
        req.body = {:date_option_id => date_option_id.to_i}
      end
    end
  end
end
