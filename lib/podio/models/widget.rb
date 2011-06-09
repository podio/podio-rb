class Podio::Widget < ActivePodio::Base
  property :widget_id, :integer
  property :ref_type, :string
  property :ref_id, :integer
  property :type, :string
  property :title, :string
  property :config, :string
end
