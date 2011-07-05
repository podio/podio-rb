class Podio::QuestionAnswer < ActivePodio::Base
  property :question_option_id, :integer

  has_one :user, :class => 'User'
end