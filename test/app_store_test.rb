require 'test_helper'

class AppStoreTest < Test::Unit::TestCase
  test 'should find single category' do
    category = Podio::Category.find(1)

    assert_equal 1, category['category_id']
  end

  test 'should find all categories' do
    categories = Podio::Category.find_all

    assert_equal Array, categories.functional.class
    assert_not_nil categories.functional.first['category_id']

    assert_equal Array, categories.vertical.class
    assert_not_nil categories.vertical.first['category_id']
  end

  test 'should create category' do
    login_as_user(2)

    status = Podio::Category.create(:type => 'vertical', :name => 'New Category')
    assert_equal 200, status
  end

  test 'should update category' do
    login_as_user(2)

    status = Podio::Category.update(1, :name => 'New name')
    assert_equal 204, status
  end

  test 'should delete category' do
    login_as_user(2)

    status = Podio::Category.delete(3)
    assert_equal 204, status
  end
end
