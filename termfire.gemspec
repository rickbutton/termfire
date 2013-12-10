# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'termfire/version'

Gem::Specification.new do |spec|
  spec.name          = "termfire"
  spec.version       = Termfire::VERSION
  spec.authors       = ["Rick Button"]
  spec.email         = ["me@rickybutton.com"]
  spec.description   = %q{Campfire CLI client}
  spec.summary       = %q{Campfire CLI client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "tinder"
  spec.add_runtime_dependency "ncurses-ruby"
end
