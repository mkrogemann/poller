# -*- encoding: utf-8 -*-
require File.expand_path('../lib/poller/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Markus Krogemann"]
  gem.email         = ["markus@krogemann.de"]
  gem.description   = %q{Implementations of Poller and Probe as inspired by Steve Freeman and Nat Pryce in their GOOS book}
  gem.summary       = %q{Pollers and Probes}
  gem.homepage      = "https://github.com/mkrogemann/poller"
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = []
  gem.name          = "poller"
  gem.require_paths = ["lib"]
  gem.version       = Poller::VERSION

  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    gem.add_runtime_dependency('rubysl', '~> 2.0')
    gem.add_runtime_dependency('rubinius-coverage', '~> 2.0.3')
  end
  gem.add_development_dependency('rspec', '~> 2.14.1')
  gem.add_development_dependency('simplecov', '~> 0.8.2')
end
