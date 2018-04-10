$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'podio/version'

Gem::Specification.new do |s|
  s.name              = 'podio'
  s.version           = Podio::VERSION
  s.platform          = Gem::Platform::RUBY
  s.summary           = 'Ruby wrapper for the Podio API'
  s.description       = 'The official Ruby wrapper for the Podio API used and maintained by the Podio team'
  s.license           = 'MIT'

  s.authors           = ['Florian Munz', 'Casper Fabricius']
  s.email             = 'surf@theflow.de'
  s.homepage          = 'https://github.com/podio/podio-rb'

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths     = ['lib']

  s.has_rdoc          = false

  s.add_dependency 'faraday', '>= 0.8.0', '< 1.0'
  s.add_dependency 'multi_json'

  if RUBY_VERSION > '2.4'
    s.add_dependency 'activesupport', '>= 4.2'
    s.add_dependency 'activemodel', '>= 4.2'
  else
    s.add_dependency 'activesupport', '>= 3.0'
    s.add_dependency 'activemodel', '>= 3.0'
  end

  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
end
