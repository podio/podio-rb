require 'test/unit'
require 'yajl'

require 'podio'


ENABLE_STUBS  = ENV['ENABLE_STUBS'] == 'true'
ENABLE_RECORD = ENV['ENABLE_RECORD'] == 'true'

class Test::Unit::TestCase

  def setup
    set_podio_client
    stub_responses if ENABLE_STUBS
  end

  # test "verify something" do
  #   ...
  # end
  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end

  def set_podio_client(user_id = 1)
    Podio.client = Podio::Client.new(
      :api_url      => 'http://127.0.0.1:8080',
      :api_key      => 'dev@hoisthq.com',
      :api_secret   => 'CmACRWF1WBOTDfOa20A',
      :enable_stubs => ENABLE_STUBS && !ENABLE_RECORD,
      :record_mode  => ENABLE_RECORD,
      :test_mode    => true,
      :oauth_token  => new_token_for_user(user_id)
    )
  end

  def login_as_user(user_id)
    set_podio_client(user_id)
  end

  def stub_responses
    folder_name = self.class.name.underscore.gsub('_test', '')
    current_folder = File.join(File.dirname(__FILE__), 'fixtures', folder_name)

    Dir.foreach(current_folder) do |filename|
      next unless filename.include?('.rack')

      rack_response = eval(File.read(File.join(current_folder, filename)))

      url    = rack_response.shift
      method = rack_response.shift

      Podio.client.stubs.send(method, url) { rack_response }
    end
  end

  def new_token_for_user(user_id)
    tokens = {
      1 => '352e85cd67eff86179194515b91a75404c1169ad083ad435b200af834b9121665b2aaf894f599b7d9b1bee6b7551f3a11e2a02dc43def9a9b549b1f2a4fe9a42',
      2 => '58ac6854ac3e8d7e8797ed5b37ba8dfeca4224cabcd4ad4f04a5f328c83d9edb3be911e6fbccf742841369734ab26136c66380385e58ff2b5da03f7fe45852b1'
    }

    Podio::OAuthToken.new(
      'access_token' => tokens[user_id],
      'refresh_token' => '82e7a11ae187f28a25261599aa6229cd89f8faee48cba18a75d70efae88ba665ced11d43143b7f5bebb31a4103662b851dd2db1879a3947b843259479fccfad3',
      'expires_in' => 3600
    )
  end
end
