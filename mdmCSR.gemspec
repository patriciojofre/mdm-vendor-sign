# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mdmCSR/version'

Gem::Specification.new do |spec|
  spec.name          = "mdmCSR"
  spec.version       = MdmCSR::VERSION
  spec.authors       = ["patricio jofre"]
  spec.email         = ["luis.jofre.g@gmail.com"]

  spec.summary       = "Apple MDM vendor CSR signing"
  spec.description   = "Apple MDM vendor CSR signing"
  spec.homepage      = "https://github.com/patriciojofre"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rspec", "~> 3.0"
end
