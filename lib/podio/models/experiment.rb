class Podio::Experiment < ActivePodio::Base

  class << self

    def create_subject(attributes)
      response = Podio.client.trusted_connection.post do |req|
        req.url '/experiment/subject/'
        req.body = attributes
      end
      response.body['identifier']
    end

    def associate_subject(identifier)
      Podio.connection.post("/experiment/subject/#{identifier}/associate")
    end

    def find_variation_for_subject(identifier, experiment, supported_variations)
      response = Podio.client.trusted_connection.post do |req|
        req.url "/experiment/#{experiment}/subject/#{identifier}"
        req.body = supported_variations
      end
      response.body['variation']
    end

    def find_variation_for_user(experiment, supported_variations)
      response = Podio.connection.post do |req|
        req.url "/experiment/#{experiment}/user"
        req.body = supported_variations
      end
      response.body['variation']
    end

    def find_all
      Podio.connection.get('/experiment/').body
    end

    def create_variation(experiment, variation)
      Podio.connection.post("/experiment/#{experiment}/variation/#{variation}")
    end

    def activate_variation(experiment, variation)
      Podio.connection.post("/experiment/#{experiment}/variation/#{variation}/activate")
    end

    def deactivate_variation(experiment, variation)
      Podio.connection.post("/experiment/#{experiment}/variation/#{variation}/deactivate")
    end

    def assign_variation(experiment, variation, attributes)
      Podio.connection.post do |req|
        req.url "/experiment/#{experiment}/variation/#{variation}/assign"
        req.body = attributes
      end
    end

  end
end
