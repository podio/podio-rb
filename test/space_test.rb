require_relative 'test_helper'

class SpaceTest < ActiveSupport::TestCase
  test 'should find single space' do
    space = Podio::Space.find(1)

    assert_equal 1, space['space_id']
    assert_equal 'API', space['name']
  end

  test 'should find all for org' do
    spaces = Podio::Space.find_all_for_org(1)

    assert spaces.is_a?(Array)
    assert_not_nil spaces.first['name']
  end
end
