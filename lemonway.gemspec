# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lemonway/version'

Gem::Specification.new do |spec|
  spec.name          = "lemonway"
  spec.version       = Lemonway::VERSION
  spec.authors       = ["Itkin"]
  spec.email         = ["nicolas.papon@gmail.com"]
  spec.description   = "Lemon way SOAP whitelabel client built on top of savon"
  spec.summary       = "Lemon way SOAP whitelabel client built on top of savon"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"


  spec.add_dependency "savon"
  spec.add_dependency "activesupport"


end
