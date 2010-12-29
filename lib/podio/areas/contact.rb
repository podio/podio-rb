module Podio
  module Contact
    include Podio::ResponseWrapper
    extend self

    def find(user_id)
      member Podio.connection.get("/contact/#{user_id}").body
    end

    def find_all_for_org(org_id, options={})
      options.assert_valid_keys(:key, :value, :limit, :offset, :type, :order)
      options[:type] ||= 'full'

      list Podio.connection.get { |req|
        req.url("/contact/org/#{org_id}", options)
      }.body
    end
  end
end
