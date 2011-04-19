module Podio
  module Item
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/item/#{id}").body
    end

    def find_basic(id)
      member Podio.connection.get("/item/#{id}/basic").body
    end

    def find_all_by_external_id(app_id, external_id)
      collection Podio.connection.get("/item/app/#{app_id}/v2/?external_id=#{external_id}").body
    end

    def find_all(app_id, options={})
      collection Podio.connection.get { |req|
        req.url("/item/app/#{app_id}/", options)
      }.body
    end
    
    def find_next(current_item_id, time = nil)
      find_next_or_previous(:next, current_item_id, time)
    end

    def find_previous(current_item_id, time = nil)
      find_next_or_previous(:previous, current_item_id, time)
    end

    def create(app_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/item/app/#{app_id}/"
        req.body = attributes
      end

      response.body['item_id']
    end
    
    def delete(id)
      Podio.connection.delete("/item/#{id}").body
    end
    
    protected
    
      def time_options(time)
        time.present? ? { 'time' => (time.is_a?(String) ? time : time.to_s(:db)) } : {}
      end
      
      def find_next_or_previous(operation, current_item_id, time)
        member Podio.connection.get { |req|
          req.url("/item/#{current_item_id}/#{operation}", time_options(time))
        }.body
      end
    
  end
end
