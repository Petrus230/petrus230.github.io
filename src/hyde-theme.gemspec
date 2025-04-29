# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hyde-theme"
  spec.version       = "1.0.0"
  spec.authors       = ["Lluis Guirado"]

  spec.summary       = "An inarguably well-designed theme for Jekyll."
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(assets|scripts|_(includes|layouts|sass|pages|posts|data)/|(LICENSE|README)((\.(txt|md|markdown)|$)))}i)
  end

  spec.add_development_dependency "jekyll", "~> 4.4.1"
  spec.add_development_dependency "jekyll-polyglot", "~> 1.9"
  spec.add_development_dependency "jekyll-redirect-from", "~> 0.16.0"
  spec.add_development_dependency "jekyll-date-localization", "~> 0.0.8"
  spec.add_development_dependency "jekyll-minifier", "~> 0.1.10"
  spec.add_development_dependency "jekyll-sitemap", "~> 1.4.0"
  spec.add_development_dependency "jekyll-feed", "~> 0.17.0"
  spec.add_development_dependency "bundler", "~> 2.6.5"
  spec.add_development_dependency "rake", "~> 13.2.1"
end