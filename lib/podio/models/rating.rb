# @see https://developers.podio.com/doc/ratings
class Podio::Rating < ActivePodio::Base

  property :rating_id, :integer
  property :type, :string
  property :value, :string

  alias_method :id, :rating_id

  class << self
    # @see https://developers.podio.com/doc/ratings/add-rating-22377
    def create(ref_type, ref_id, rating_type, value)
      response = Podio.connection.post do |req|
        req.url "/rating/#{ref_type}/#{ref_id}/#{rating_type}"
        req.body = { :value => value }
      end

      response.body['rating_id']
    end

    # @see https://developers.podio.com/doc/ratings/get-all-ratings-22376
    def find_all(ref_type, ref_id)
      collection Podio.connection.get("/rating/#{ref_type}/#{ref_id}").body
    end

    # @see https://developers.podio.com/doc/ratings/get-rating-22407
    def find(ref_type, ref_id, rating_type, user_id)
      Podio.connection.get("/rating/#{ref_type}/#{ref_id}/#{rating_type}/#{user_id}").body['value']
    end

    # @see https://developers.podio.com/doc/ratings/get-rating-own-84128
    def find_own(ref_type, ref_id, rating_type)
      Podio.connection.get("/rating/#{ref_type}/#{ref_id}/#{rating_type}/self").body['value']
    end

    # @see https://developers.podio.com/doc/ratings/get-ratings-22375
    def find_all_by_type(ref_type, ref_id, rating_type)
      collection Podio.connection.get("/rating/#{ref_type}/#{ref_id}/#{rating_type}").body
    end

    # @see https://developers.podio.com/doc/ratings/remove-rating-22342
    def delete(ref_type, ref_id, rating_type)
      Podio.connection.delete("/rating/#{ref_type}/#{ref_id}/#{rating_type}").body
    end

    # @see https://developers.podio.com/doc/comments/get-who-liked-a-comment-29007011
    def liked_by(ref_type, ref_id)
      Podio.connection.get("/rating/#{ref_type}/#{ref_id}/liked_by/").body.map{|values| Podio::Contact.new(values)}
    end

    # @see https://developers.podio.com/doc/ratings/get-like-count-32161225
    def like_count(ref_type, ref_id)
      Podio.connection.get("/rating/#{ref_type}/#{ref_id}/like_count").body["like_count"]
    end

  end

end
