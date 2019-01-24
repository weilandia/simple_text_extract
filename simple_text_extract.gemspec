# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_text_extract/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_text_extract"
  spec.version       = SimpleTextExtract::VERSION
  spec.authors       = ["Nick Weiland"]
  spec.email         = ["nickweiland@gmail.com"]

  spec.summary       = "Attempts to quickly extract text from various file types before resorting to something more extreme like Apache Tika."
  spec.description   = "Attempts to quickly extract text from various file types before resorting to something more extreme like Apache Tika. Built with ActiveStorage in mind."
  spec.homepage      = "https://github.com/weilandia/simple_text_extract"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.requirements << "antiword"
  spec.requirements << "pdftotext/poppler"
  spec.requirements << "gnumeric"
  spec.required_ruby_version = ">= 2.5"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha"
end
