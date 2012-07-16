class Podio::Reference < ActivePodio::Base

  property :type, :string
  property :id, :integer
  property :title, :string
  property :link, :string
  property :data, :hash
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  class << self
    def find(ref_type, ref_id, options = {})
      member Podio.connection.get { |req|
        req.url("/reference/#{ref_type}/#{ref_id}", options)
      }.body
    end
  end
end
