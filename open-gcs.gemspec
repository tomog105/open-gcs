
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "open-gcs/version"

Gem::Specification.new do |spec|
  spec.name          = "open-gcs"
  spec.version       = OpenGCS::VERSION
  spec.authors       = ["tomog105"]
  spec.email         = ["knowide@gmail.com"]

  spec.summary       = %q{GCS file open wrapper.}
  spec.description   = %q{GCS file open wrapper.}
  spec.homepage      = "https://github.com/tomog105/open-gcs"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency "google-cloud-storage", ">= 1.9.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit", ">= 3.2.7"
  spec.add_development_dependency "test-unit-rr"
end
