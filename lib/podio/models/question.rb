class Podio::Question < ActivePodio::Base

  property :question_id, :integer
  property :text, :string
  property :ref, :hash

  has_many :answers, :class => 'QuestionAnswer'
  has_many :options, :class => 'QuestionOption'

  alias_method :id, :question_id

  class << self

    def create(ref_type, ref_id, text, options)
      response = Podio.connection.post do |req|
        req.url "/question/#{ref_type}/#{ref_id}/"
        req.body = {:text => text, :options => options }
      end
      member response.body
    end

    def answer(question_id, ref_type, ref_id, question_option_id)
      response = Podio.connection.post do |req|
        req.url "/question/#{question_id}/#{ref_type}/#{ref_id}/"
        req.body = {:question_option_id => question_option_id }
      end
      
      response.status
    end

  end
end