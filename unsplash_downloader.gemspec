# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unsplash_downloader/version'

Gem::Specification.new do |spec|
  spec.name          = "unsplash_downloader"
  spec.version       = UnsplashDownloader::VERSION
  spec.authors       = ["Bartłomiej Jacak"]
  spec.email         = ["bartek.jacak@gmail.com"]

  spec.summary       = %q{Unsplash downloader written in Ruby.}
  spec.homepage      = "https://github.com/xennon/unsplash-downloader"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r['bin/unsplash_downloader'])
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "mechanize", "~> 2.7.0"
  spec.add_dependency "thor"
end