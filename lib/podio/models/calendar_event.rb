# @see https://developers.podio.com/doc/calendar
class Podio::CalendarEvent < ActivePodio::Base
  property :type, :string
  property :id, :integer
  property :group, :string
  property :title, :string
  property :description, :string
  property :location, :string
  property :status, :string
  property :start, :datetime, :convert_timezone => false
  property :start_date, :date
  property :start_time, :string
  property :end, :datetime, :convert_timezone => false
  property :end_date, :date
  property :end_time, :string
  property :link, :string

  class << self

    # @see https://developers.podio.com/doc/calendar/get-global-calendar-22458
    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url('/calendar/', options)
      }.body
    end

    # @see https://developers.podio.com/doc/calendar/get-space-calendar-22459
    def find_all_for_space(space_id, options={})
      list Podio.connection.get { |req|
        req.url("/calendar/space/#{space_id}/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/calendar/get-app-calendar-22460
    def find_all_for_app(app_id, options={})
      list Podio.connection.get { |req|
        req.url("/calendar/app/#{app_id}/", options)
      }.body
    end

    def get_calendars_for_linked_acc(acc_id, options={})
      list Podio.connection.get { |req|
        req.url("/calendar/export/linked_account/#{acc_id}/available", options)
      }.body
    end

    # @see https://developers.podio.com/doc/calendar/get-calendar-summary-1609256
    def find_summary(options = {})
      response = Podio.connection.get do |req|
        req.url("/calendar/summary", options)
      end.body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    # @see https://developers.podio.com/doc/calendar/get-calendar-summary-for-space-1609328
    def find_summary_for_space(space_id)
      response = Podio.connection.get("/calendar/space/#{space_id}/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    def find_summary_for_org(org_id)
      response = Podio.connection.get("/calendar/org/#{org_id}/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    # @see https://developers.podio.com/doc/calendar/get-calendar-summary-for-personal-1657903
    def find_personal_summary
      response = Podio.connection.get("/calendar/personal/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    # @see https://developers.podio.com/doc/calendar/set-reference-export-9183515
    def set_reference_export(linked_account_id, ref_type, ref_id, attributes={})
      response = Podio.connection.put do |req|
        req.url "/calendar/export/linked_account/#{linked_account_id}/#{ref_type}/#{ref_id}"
        req.body = attributes
      end
      response.status
    end

    # @see https://developers.podio.com/doc/calendar/get-exports-by-reference-7554180
    def get_reference_exports(ref_type, ref_id)
      list Podio.connection.get { |req|
        req.url("/calendar/export/#{ref_type}/#{ref_id}/")
      }.body
    end

    # @see https://developers.podio.com/doc/calendar/stop-reference-export-9183590
    def stop_reference_export(linked_account_id, ref_type, ref_id)
      Podio.connection.delete("/calendar/export/linked_account/#{linked_account_id}/#{ref_type}/#{ref_id}").status
    end

    # @see https://developers.podio.com/doc/calendar/get-global-export-9381099
    def set_global_export(linked_account_id, attributes={})
      response = Podio.connection.put do |req|
        req.url "/calendar/export/linked_account/#{linked_account_id}"
        req.body = attributes
      end
      response.status
    end

    # @see https://developers.podio.com/doc/calendar/get-global-exports-7554169
    def get_global_exports()
      list Podio.connection.get { |req|
        req.url("/calendar/export/")
      }.body
    end

    def stop_global_export(linked_account_id)
      Podio.connection.delete("/calendar/export/linked_account/#{linked_account_id}").status
    end

  end

end
