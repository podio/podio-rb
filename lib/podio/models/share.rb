# TODO: Unfinished code, pending API implementation for correct attribute names
class Podio::Share < ActivePodio::Base

  property :ref_type, :string
  property :ref_id, :integer
  property :contacts, :hash
  property :message, :string
  property :actions, :array

  def save
    self.class.create(self.ref_type, self.ref_id, self.attributes)
  end

  handle_api_errors_for :save

  class << self
    def create(ref_type, ref_id, attributes={})
      return true

      # TODO: Make correct call once implemented in the API
      response = Podio.connection.post do |req|
        req.url "/share/#{ref_type}/#{ref_id}"
        req.body = attributes
      end

      response.body
    end
  end
end
