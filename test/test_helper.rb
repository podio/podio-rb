require 'test/unit'
require 'yajl'
require 'fakeweb'

require 'podio'


FakeWeb.allow_net_connect = false

def podio_test_client
  Podio::Client.new(:api_url => 'https://api.podio.com', :api_key => 'client_id', :api_secret => 'client_secret')
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, body, options = {})
  opts = {
    :body => body.is_a?(String) ? body : Yajl::Encoder.encode(body),
    :content_type => 'application/json; charset=utf-8'
  }.merge(options)
  FakeWeb.register_uri(:get, "https://api.podio.com#{url}", opts)
end

def stub_post(url, body, options = {})
  opts = {
    :body => body.is_a?(String) ? body : Yajl::Encoder.encode(body),
    :content_type => 'application/json; charset=utf-8'
  }.merge(options)
  FakeWeb.register_uri(:post, "https://api.podio.com#{url}", opts)
end


##
# test/spec/mini 5
# http://gist.github.com/307649
# chris@ozmm.org
#
def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(defined?(ActiveSupport::TestCase) ? ActiveSupport::TestCase : Test::Unit::TestCase) do
    def self.test(name, &block)
      define_method("test_#{name.to_s.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.context(*args, &block) instance_eval(&block) end
    def self.setup(&block)
      define_method(:setup) { self.class.setups.each { |s| instance_eval(&s) } }
      setups << block
    end
    def self.setups; @setups ||= [] end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval(&block)
end
