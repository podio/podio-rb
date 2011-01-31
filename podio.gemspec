$:.push File.expand_path('../lib', __FILE__)
require 'podio/version'

Gem::Specification.new do |s|
  s.name              = 'podio'
  s.version           = Podio::VERSION
  s.platform          = Gem::Platform::RUBY
  s.summary           = 'Ruby wrapper for the Podio API'
  s.homepage          = 'https://github.com/podio/podio-rb'
  s.email             = 'florian@podio.com'
  s.authors           = ['Florian Munz']
  s.has_rdoc          = false

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths     = ['lib']

  s.add_runtime_dependency 'faraday', '~> 0.5.1'
  s.add_runtime_dependency 'activesupport', '~> 3.0'
  s.add_runtime_dependency 'multi_json', '~> 0.0.5'

  s.description       = <<desc
The humble beginnings of the Ruby wrapper for the Podio API.
desc
end
