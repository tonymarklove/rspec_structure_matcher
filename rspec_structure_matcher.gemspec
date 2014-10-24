# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_structure_matcher"
  spec.version       = RspecStructureMatcher::VERSION
  spec.authors       = ["Tony Marklove"]
  spec.email         = ["tony@new-bamboo.co.uk"]
  spec.description   = %q{Rspec matchers for structured JSON responses. Compare expected keys, value types, or even match values against regular expressions.}
  spec.summary       = %q{Rspec matchers for structured JSON responses.}
  spec.homepage      = "https://github.com/jjbananas/rspec_structure_matcher"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
