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

    def find(org_id, user_id)
      member Podio.connection.get("/org/#{org_id}/member/#{user_id}").body
    end
    
    def delete(org_id, user_id)
      Podio.connection.delete("/org/#{org_id}/member/#{user_id}").status
    end
    
    def make_admin(org_id, user_id)
      response = Podio.connection.post do |req|
        req.url "/org/#{org_id}/admin/"
        req.body = { :user_id => user_id.to_i }
      end
      response.status
    end

    def remove_admin(org_id, user_id)
      Podio.connection.delete("/org/#{org_id}/admin/#{user_id}").status
    end
    
  end
end