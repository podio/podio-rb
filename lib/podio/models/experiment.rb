class Podio::Experiment < ActivePodio::Base
  class Podio::Variation < ActivePodio::Base
    property :name, :string
    property :weight, :integer
    property :active, :boolean
  end

  property :name, :string
  has_many :variations, :class => 'Variation'

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
      list Podio.connection.get('/experiment/').body
    end

    def find(experiment)
      member Podio.connection.get("/experiment/#{experiment}").body
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

    def delete_variation(experiment, variation)
      Podio.connection.delete("/experiment/#{experiment}/variation/#{variation}")
    end

    def update_variation_weight(experiment, variation, weight)
      Podio.connection.post do |req|
        req.url "/experiment/#{experiment}/variation/#{variation}/weight"
        req.body = { "weight" => weight }
      end
    end

    def assign_variation(experiment, variation, attributes)
      Podio.connection.post do |req|
        req.url "/experiment/#{experiment}/variation/#{variation}/assign"
        req.body = attributes
      end
    end

    def combined(supported_variations_map, identifier=nil, attributes={})
      connection = Podio.client.oauth_token ? Podio.client.connection : Podio.client.trusted_connection

      body = attributes.merge({
        "experiments" => supported_variations_map
      })

      body["identifier"] = identifier if identifier.present?

      connection.post do |req|
        req.url "/experiment/combined"
        req.body = body
      end.body
    end
  end
end
