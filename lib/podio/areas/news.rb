module Podio
	module News
		include Podio::ResponseWrapper
		extend self

		def create(attributes)
			response = Podio.connection.post do |req|
				req.url = '/news'
				req.body = attributes
			end

			response.body['news_id']
		end

		def update(id, attributes)
			response = Podio.connection.post do |req|
				req.url "/news/#{id}"
				req.body = attributes
			end

			response.status
		end

		def find(id, options={})
			member Podio.connection.get("/news/#{id}").body
		end

		def find_visible
			list Podio.connection.get("/news/").body
		end

		def find_all
			list  Podio.connection.get("/news/?show_drafts=1").body
		end

		def find_all_by_locale(locale)
			list Podio.connection.get('/news/?locale=#{locale}').body
		end
	end
end