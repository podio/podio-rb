$:.push File.expand_path('../lib', __FILE__)
require 'podio/version'

Gem::Specification.new do |s|
  s.name              = 'podio'
  s.version           = Podio::VERSION
  s.platform          = Gem::Platform::RUBY
  s.summary           = 'Ruby wrapper for the Podio API'
  s.homepage          = 'https://github.com/podio/podio-rb'
  s.email             = 'florian@podio.com'
  s.authors           = ['Florian Munz', 'Casper Fabricius']
  s.has_rdoc          = false

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths     = ['lib']

  s.add_dependency('faraday', '~> 0.8.0')
  s.add_dependency('activesupport', '~> 3.0')
  s.add_dependency('activemodel', '~> 3.0')
  s.add_dependency('multi_json')
  s.add_development_dependency('rake')
  s.add_development_dependency('yard')

  s.description       = <<desc
The official Ruby wrapper for the Podio API used and maintained by the Podio team
desc
end
