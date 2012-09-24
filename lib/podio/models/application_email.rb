# @see https://developers.podio.com/doc/email
class Podio::ApplicationEmail < ActivePodio::Base
  include ActivePodio::Updatable

  property :attachments, :boolean
  property :mappings, :hash

  class << self
    # @see https://developers.podio.com/doc/email/get-app-email-configuration-622338
    def get_app_configuration(app_id)
      member Podio.connection.get { |req|
        req.url("/email/app/#{app_id}", {})
      }.body
    end

    # @see https://developers.podio.com/doc/email/update-app-email-configuration-622851
    def update_app_configuration(app_id, options)
      Podio.connection.put { |req|
        req.url "/email/app/#{app_id}"
        req.body = options
      }.body
    end

  end
end
