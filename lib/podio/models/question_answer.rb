class Podio::QuestionAnswer < ActivePodio::Base
  property :question_option_id, :integer

  # the key is called user, but the API actually returns a Profile/Contact
  has_one :user, :class => 'Contact'
end
