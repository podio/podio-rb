class ApplicationEmail < ActivePodio::Base
  property :attachments, :boolean
  property :mappings, :hash  
end
