# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textveloper/version'

Gem::Specification.new do |spec|
  spec.name          = "textveloper"
  spec.version       = Textveloper::VERSION
  spec.authors       = ["Gustavo Gimenez"]
  spec.email         = ["gimenezanderson@gmail.com"]
  spec.description   = %q{Envío de mensajes de texto en Venezuela a tráves del servicio de Textveloper}
  spec.summary       = %q{Gema para el envío de sms en Venezuela a tráves del servicio de Textveloper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "curb"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "curb"
  spec.add_development_dependency "webmock"


end
