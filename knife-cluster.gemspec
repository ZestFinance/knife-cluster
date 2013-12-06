# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-cluster/version'

Gem::Specification.new do |spec|
  spec.name          = "knife-cluster"
  spec.version       = Knife::Cluster::VERSION
  spec.authors       = ["Chris Rosario && Xintong Zhang"]
  spec.email         = ["xz@zestfinance.com"]
  spec.description   = %q{Manage a cluster of EC2 instances with Chef from command line}
  spec.summary       = %q{Manage a cluster of EC2 instances with Chef from command line}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "chef"
  spec.add_dependency "fog", "1.9.0"
  spec.add_dependency "knife-instance"

  spec.add_development_dependency "bundler", "~> 1.4"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "debugger"
end
