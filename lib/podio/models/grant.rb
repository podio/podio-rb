class Podio::Grant < ActivePodio::Base

  property :ref_type, :string
  property :ref_id, :integer
  property :people, :hash
  property :action, :string
  property :message, :string

  has_one :created_by, :class => 'ByLine'

  def save
    self.class.create(self.ref_type, self.ref_id, self.attributes)
  end

  handle_api_errors_for :save

  class << self
    def create(ref_type, ref_id, attributes={})
      response = Podio.connection.post do |req|
        req.url "/grant/#{ref_type}/#{ref_id}"
        req.body = attributes
      end

      response.body
    end

    def find_own(ref_type, ref_id)
      member Podio.connection.get("/grant/#{ref_type}/#{ref_id}/own").body
    end
  end
end
