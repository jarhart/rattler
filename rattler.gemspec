# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rattler/version'

Gem::Specification.new do |spec|
  spec.name          = "rattler"
  spec.version       = Rattler::VERSION
  spec.authors       = ["Jason Arhart"]
  spec.email         = ["jarhart@gmail.com"]
  spec.description   = %q{Simple language recognition tool for Ruby based on packrat parsing}
  spec.summary       = %q{Simple language recognition tool for Ruby based on packrat parsing}
  spec.homepage      = "https://github.com/jarhart/rattler"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
