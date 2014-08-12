# @see https://developers.podio.com/doc/oauth-authorization
class Podio::OAuthScope < ActivePodio::Base
  include ActivePodio::Updatable

  property :ref_type, :string
  property :ref_id, :integer
  property :ref_link, :string
  property :ref_name, :string
  property :permission, :string

end
