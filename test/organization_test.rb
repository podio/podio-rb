require 'test_helper'

class OrganizationTest < Test::Unit::TestCase
  test 'should find single organization' do
    org = Podio::Organization.find(1)

    assert_equal 1, org['org_id']
    assert_equal 'Hoist', org['name']
  end

  test 'should delete org' do
    response = Podio::Organization.delete(1)
    assert_equal 204, response
  end

  test 'should update org' do
    response = Podio::Organization.update(1, :name => 'New name')
    assert_equal 204, response
  end
end
