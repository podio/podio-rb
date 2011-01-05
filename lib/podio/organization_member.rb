module Podio
  module OrganizationMember
    include Podio::ResponseWrapper
    extend self

    def find_all_for_org(org_id, options = {})
      options.assert_valid_keys(:sort_by, :sort_desc, :limit, :offset)

      list Podio.connection.get { |req|
        req.url("/org/#{org_id}/member/", options)
      }.body
    end
  end
end