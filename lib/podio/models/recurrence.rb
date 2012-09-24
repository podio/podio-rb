# @see https://developers.podio.com/doc/recurrence
class Podio::Recurrence < ActivePodio::Base
  property :recurrence_id, :integer
  property :name, :string
  property :config, :hash
  property :step, :integer
  property :until, :date

  alias_method :id, :recurrence_id
  delegate_to_hash :config, :days, :repeat_on, :setter => true

  class << self
    # @see https://developers.podio.com/doc/recurrence/delete-recurrence-3349970
    def delete(ref_type, ref_id)
      Podio.connection.delete("/recurrence/#{ref_type}/#{ref_id}").body
    end

    # @see https://developers.podio.com/doc/recurrence/create-or-update-recurrence-3349957
    def update(ref_type, ref_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/recurrence/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end
  end

end
