class Podio::Form < ActivePodio::Base
  property :form_id, :integer
  property :app_id, :integer
  property :settings, :hash
  property :domains, :array
  property :field_ids, :array
  property :attachments, :boolean
  
  alias_method :id, :form_id
  delegate_to_hash :settings, :captcha, :text, :theme
  delegate_to_hash :text, :submit, :success
  
  class << self
    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/form/app/#{app_id}/"
        req.body = attributes
      end

      response.body['form_id']
    end

    def find_all_for_app(app_id)
      list Podio.connection.get { |req|
        req.url("/form/app/#{app_id}/")
      }.body
    end

    def find(form_id)
      member Podio.connection.get("/form/#{form_id}").body
    end
  end
end
