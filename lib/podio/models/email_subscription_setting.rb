class Podio::EmailSubscriptionSetting < ActivePodio::Base
  include ActivePodio::Updatable

  property :digest, :boolean
  property :bulletin, :boolean
  property :reference, :boolean
  property :message, :boolean
  property :space, :boolean
  property :subscription, :boolean

  def self.find_for_current_user
    self.get_groups
  end
  
  def update
    self.class.update_groups(self.attributes)
  end

end
