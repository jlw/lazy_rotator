# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_rotator/version'

Gem::Specification.new do |spec|
  spec.name          = 'lazy_rotator'
  spec.version       = LazyRotator::VERSION
  spec.authors       = ['Jeremy Weathers']
  spec.email         = ['jeremy@codekindly.com']

  spec.summary       = 'Lazily rotate log files'
  spec.description   = "Tie log (or other file) rotation to the (un-scheduled?) execution of code. The raison d'étre for this gem is that I'm too lazy to clear out test and development logs manually and am too anal-retentive to be happy with large log files accumulating in my various project directories."
  spec.homepage      = 'https://github.com/jlw/lazy_rotator'
  spec.license       = 'Unlicense'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
