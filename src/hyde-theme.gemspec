# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hyde-theme"
  spec.version       = "1.0.0"
  spec.authors       = ["Lluis Guirado"]

  spec.summary       = "An inarguably well-designed theme for Jekyll."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.4.1"

  spec.add_development_dependency "bundler", "~> 2.6.5"
  spec.add_development_dependency "rake", "~> 13.2.1"
end
