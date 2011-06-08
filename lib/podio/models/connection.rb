class Podio::Connection < ActivePodio::Base
  property :connection_id, :integer
  property :type, :string
  property :name, :string
  property :last_load_on, :datetime
  property :created_on, :datetime

  property :contact_count, :integer

  alias_method :id, :connection_id

  def reload
    Connection.reload(id)
  end

  def destroy
    Connection.delete(id)
  end
end
