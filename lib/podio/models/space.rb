class Podio::Space < ActivePodio::Base
  property :space_id, :integer
  property :name, :string
  property :url, :string
  property :url_label, :string
  property :org_id, :integer
  property :contact_count, :integer
  property :members, :integer
  property :role, :string
  property :rights, :array
  
  has_one :created_by, :class => Podio::ByLine

  alias_method :id, :space_id
  
  def create
    response = Space.create(:org_id => org_id, :name => name)
    self.url = response['url']
    self.space_id = response['space_id']
  end
end

