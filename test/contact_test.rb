require 'test_helper'

class ContactTest < Test::Unit::TestCase
  test 'should find single contact' do
    contact = Podio::Contact.find(1)

    assert_equal 1, contact['user_id']
    assert_equal 'King of the API, baby!', contact['about']
  end

  test 'should find all for org' do
    contacts = Podio::Contact.find_all_for_org(1)

    assert contacts.size > 0
    assert_not_nil contacts.first['user_id']
  end

  test 'should find all for org filtered by key' do
    contacts = Podio::Contact.find_all_for_org(1, :key => 'organization', :value => 'Hoist')

    assert contacts.size > 0
    contacts.each do |contact|
      assert_equal 'Hoist', contact['organization']
    end
  end
end
