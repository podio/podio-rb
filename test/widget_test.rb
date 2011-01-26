require 'test_helper'

class WidgetTest < Test::Unit::TestCase
  test 'should find single widget' do
    widget = Podio::Widget.find(1)

    assert_equal 1, widget['widget_id']
    assert_equal 'State count', widget['title']
  end

  test 'should find all for reference' do
    widgets = Podio::Widget.find_all_for_reference(:app, 1)

    assert widgets.is_a?(Array)
    assert widgets.size > 0
  end

  test 'should find nothing for reference' do
    # no widgets exists for this space
    widgets = Podio::Widget.find_all_for_reference(:space, 2)
    assert_equal [], widgets
  end

  test 'should create widget' do
    response = Podio::Widget.create(:app, 1, {
      :type => :text,
      :title => 'widget title',
      :config => {:text => 'widget'}
    })

    assert response.is_a?(Integer)
  end

  test 'should not create widget with missing field' do
    assert_raises Podio::Error::BadRequestError do
      Podio::Widget.create(:app, 1, :title => 'widget title', :config => {:text => 'widget'})
    end
  end

  test 'should update widget' do
    status = Podio::Widget.update(3, :title => 'Updated title', :config => {:text => 'updated text'})
    assert_equal 204, status
  end

  test 'should delete widget' do
    status = Podio::Widget.delete(1)
    assert_equal 204, status
  end

  test 'should update order of widgets' do
    widgets_ids = Podio::Widget.find_all_for_reference(:space, 1).map { |w| w['widget_id'] }

    Podio::Widget.update_order(:space, 1, widgets_ids.reverse)
  end
end
