# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sgupdater/version'

Gem::Specification.new do |spec|
  spec.name          = "sgupdater"
  spec.version       = Sgupdater::VERSION
  spec.authors       = ["ISOBE Kazuhiko"]
  spec.email         = ["muramasa64@gmail.com"]

  spec.summary       = %q{Sgupdater is a tool to update the permissions CIDR of AWS security group.}
  spec.description   = %q{Sgupdater is a tool to update the permissions CIDR of AWS security group.}
  spec.homepage      = "https://github.com/uramasa64/sgupdater"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.1"
  spec.add_development_dependency "test-unit-power_assert"

  spec.add_dependency 'aws-sdk', '~> 2.0'
  spec.add_dependency 'thor'
  spec.add_dependency 'thor-aws'
  spec.add_dependency 'piculet', '= 0.2.8'
end
