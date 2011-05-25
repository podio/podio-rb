module Podio
	module News
		include Podio::ResponseWrapper
		extend self

		def create(attributes)
			response = Podio.connection.post do |req|
				req.url '/news/'
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
			list Podio.connection.get("/news/admin/").body
		end

		def find_all_by_locale(locale)
			list Podio.connection.get('/news/?locale=#{locale}').body
		end

		def find_all_by_target_group(target_group)
			list Podio.connection.get('/news/?target_group=#{target_group}').body
		end

		def find_all_by_locale_and_group(locale, group)
			list Podio.connection.get('/news/?locale=#{locale}?target_group=#{group}').body
		end

	end
end