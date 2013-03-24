# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timelapse/version'

Gem::Specification.new do |spec|
  spec.name          = "timelapse"
  spec.version       = Timelapse::VERSION
  spec.authors       = ["Stewart McKee"]
  spec.email         = ["stewart@theizone.co.uk"]
  spec.description   = "Uses gphoto2 to interact with cameras to generate timelapses"
  spec.summary       = "Uses gphoto2 to interact with cameras to generate timelapses"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "gphoto4ruby"
  spec.add_runtime_dependency "rufus-scheduler"
  spec.add_runtime_dependency "slop"
end
