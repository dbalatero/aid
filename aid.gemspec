# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aid/version'

Gem::Specification.new do |spec|
  spec.name          = 'aid'
  spec.version       = Aid::VERSION
  spec.authors       = ['David Balatero']
  spec.email         = ['dbalatero@gmail.com']

  spec.summary       = 'A library to make repo scripts easy and discoverable.'
  spec.homepage      = 'https://github.com/dbalatero/aid'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
