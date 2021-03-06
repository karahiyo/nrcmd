# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nrcmd/version'

Gem::Specification.new do |spec|
  spec.name          = "nrcmd"
  spec.version       = Nrcmd::VERSION
  spec.authors       = ["Yusuke Shimizu"]
  spec.email         = ["a.ryuklnm@gmail.com"]
  spec.summary       = %q{A command line tool for NewRelic.}
  spec.description   = %q{A command line tool for NewRelic. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'thor'
  spec.add_dependency 'net'
  spec.add_dependency 'json'
  spec.add_dependency 'activesupport'
end
