class Podio::Hook < ActivePodio::Base
  property :hook_id, :integer
  property :status, :string
  property :type, :string
  property :url, :string

  alias_method :id, :hook_id

  attr_accessor :hookable_type, :hookable_id

  def create
    self.hook_id = self.class.create(self.hookable_type, self.hookable_id, attributes)
  end
end