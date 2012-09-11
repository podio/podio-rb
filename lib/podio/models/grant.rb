class Podio::Grant < ActivePodio::Base

  property :ref_type, :string
  property :ref_id, :integer
  property :people, :hash
  property :actions, :string
  property :message, :string

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
  end
end
