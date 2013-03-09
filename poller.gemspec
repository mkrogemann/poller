# -*- encoding: utf-8 -*-
require File.expand_path('../lib/poller/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Markus Krogemann"]
  gem.email         = ["markus@krogemann.de"]
  gem.description   = %q{Implementations of Poller and Probe as inspired by Steve Freeman and Nat Pryce in their GOOS book}
  gem.summary       = %q{Pollers and Probes}
  gem.homepage      = "https://github.com/mkrogemann/poller"
  gem.licence       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = []
  gem.name          = "poller"
  gem.require_paths = ["lib"]
  gem.version       = Poller::VERSION
  gem.add_development_dependency('rspec', '~> 2.13.0')
  gem.add_development_dependency('simplecov', '~> 0.7.1')
end
