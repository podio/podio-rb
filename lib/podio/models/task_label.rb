class Podio::TaskLabel < ActivePodio::Base
  include ActivePodio::Updatable

  property :label_id, :integer
  property :text, :string
  property :color, :string

  DEFAULT_COLOR_FOR_NEW_LABELS = 'E9E9E9'

  def create
    if self.color.nil? || self.color.empty?
      self.color = DEFAULT_COLOR_FOR_NEW_LABELS
    end
    
    self.label_id = self.class.create(self.attributes)
  end

  def destroy
    self.class.delete(self.label_id)
  end

  def update
    self.class.update(self.label_id, self.attributes)
  end
  
  class << self
    def find_all_labels
      list Podio.connection.get { |req|
        req.url("/task/label/")
      }.body
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/task/label/"
        req.body = attributes
      end

      response.body['label_id']
    end

    def delete(label_id)
      Podio.connection.delete("/task/label/#{label_id}").status
    end

    def update(label_id, attributes)
      Podio.connection.put("/task/label/#{label_id}", attributes).status
    end
  end
end
