require 'test_helper'

class SpaceTest < Test::Unit::TestCase
  def test_should_find_single_space
    space = Podio::Space.find(1)

    assert_equal 1, space['space_id']
    assert_equal 'API', space['name']
  end

  def test_should_find_all_for_org
    spaces = Podio::Space.find_all_for_org(1)

    assert spaces.is_a?(Array)
    assert_not_nil spaces.first['name']
  end
end
