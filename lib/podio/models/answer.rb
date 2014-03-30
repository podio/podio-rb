class Podio::Answer < ActivePodio::Base

  property :answer_id, :integer
  property :text, :string
  
  alias_method :id, :answer_id

end
