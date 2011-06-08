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
end
