# @see https://developers.podio.com/doc/reminders
class Podio::Reminder < ActivePodio::Base
  property :reminder_id, :integer
  property :remind_delta, :integer

  alias_method :id, :reminder_id

  class << self
    # @see https://developers.podio.com/doc/reminders/delete-reminder-3315117
    def delete(ref_type, ref_id)
      Podio.connection.delete("/reminder/#{ref_type}/#{ref_id}").body
    end

    # @see https://developers.podio.com/doc/reminders/snooze-reminder-3321049
    def snooze(ref_type, ref_id)
      Podio.connection.post("/reminder/#{ref_type}/#{ref_id}/snooze").body
    end

    # @see https://developers.podio.com/doc/reminders/create-or-update-reminder-3315055
    def create(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/reminder/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end

    # @see https://developers.podio.com/doc/reminders/create-or-update-reminder-3315055
    def update(ref_type, ref_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/reminder/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end
  end

end
