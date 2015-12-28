# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errant/version'

Gem::Specification.new do |spec|
  spec.name          = "errant"
  spec.version       = Errant::VERSION
  spec.authors       = ["Blake Hyde"]
  spec.email         = ["bhyde@on-site.com"]

  spec.summary       = %q{An implementation of "monadic," or "railway-oriented," error handling for Ruby. }
  spec.homepage      = "https://github.com/asthasr/errant"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
