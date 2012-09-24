# @see https://developers.podio.com/doc/widgets
class Podio::Widget < ActivePodio::Base
  property :widget_id, :integer
  property :ref_type, :string
  property :ref_id, :integer
  property :type, :string
  property :title, :string
  property :config, :hash
  property :ref, :hash
  property :rights, :array
  property :data, :hash

  class << self
    # @see https://developers.podio.com/doc/widgets/create-widget-22491
    def create(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/widget/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end

      response.body['widget_id']
    end

    # @see https://developers.podio.com/doc/widgets/update-widget-22490
    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/widget/#{id}"
        req.body = attributes
      end

      response.status
    end

    # @see https://developers.podio.com/doc/widgets/delete-widget-22492
    def delete(id)
      Podio.connection.delete("/widget/#{id}").status
    end

    # @see https://developers.podio.com/doc/widgets/update-widget-order-22495
    def update_order(ref_type, ref_id, widget_list)
      response = Podio.connection.put do |req|
        req.url "/widget/#{ref_type}/#{ref_id}/order"
        req.body = widget_list
      end

      response.status
    end

    # @see https://developers.podio.com/doc/widgets/get-widget-22489
    def find(id)
      member Podio.connection.get("/widget/#{id}").body
    end

    # @see https://developers.podio.com/doc/widgets/get-widgets-22494
    def find_all_for_reference(ref_type, ref_id)
      list Podio.connection.get("/widget/#{ref_type}/#{ref_id}/display/").body
    end
  end
end
