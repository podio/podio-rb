require 'test_helper'

class ItemTest < Test::Unit::TestCase
  test 'should find single item' do
    item = Podio::Item.find(1)

    assert_equal 1, item['item_id']

    assert_equal 1, item['app']['app_id']
    assert_equal 'Bugs', item['app']['name']
  end

  test 'should not find nonexistant item' do
    assert_raises Podio::Error::NotFoundError do
      Podio::Item.find(42)
    end
  end

  test 'should find items by external id' do
    items = Podio::Item.find_all_by_external_id(1, 'Bar generator')

    assert items['count'] > 0
    assert items['total_count'] > 0

    assert items['all'].is_a?(Array)
    items['all'].each do |item|
      assert_equal 'Bar generator', item['external_id']
    end
  end

  test 'should not find anything for nonexistant external ids' do
    items = Podio::Item.find_all_by_external_id(1, 'Random nonexistant')

    assert_equal [], items['all']
    assert_equal 0, items['count']
  end
end
