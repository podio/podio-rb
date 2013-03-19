class Podio::Pin < ActivePodio::Base
  property :title, :string
  property :type, :string
  property :id, :integer
  property :link, :string

  alias :ref_id :id
  alias :ref_type :type

  class << self
    def find_all(query = {})
      Podio.connection.get("/pin/?#{query.to_param}").body.map(&method(:new))
    end

    def create(ref_type, ref_id)
      new(Podio.connection.post("/pin/#{ref_type}/#{ref_id}").body)
    end

    def reorder(ref_type, ref_id, priority)
      Podio.connection.post("/pin/#{ref_type}/#{ref_id}/reorder", priority)
    end

    def delete(ref_type, ref_id)
      Podio.connection.delete("/pin/#{ref_type}/#{ref_id}")
    end
  end
end
