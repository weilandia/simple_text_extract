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
  spec.required_ruby_version = Gem::Requirement.new(">= 3.1")


  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.requirements << "antiword"
  spec.requirements << "ssconvert"
  spec.requirements << "pdftotext/poppler"

  spec.add_dependency "roo", "~> 2.10.0"
  spec.add_dependency "spreadsheet", "~> 1.3.0"
  spec.add_dependency "rubyzip", "~> 2.3.2"
end
