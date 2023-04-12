# frozen_string_literal: true

require_relative "lib/simple_text_extract/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_text_extract"
  spec.version       = SimpleTextExtract::VERSION
  spec.summary       = "Easily extract text from various file types."
  spec.homepage      = "https://github.com/weilandia/simple_text_extract"
  spec.license       = "MIT"

  spec.author        = "Nick Weiland"
  spec.email         = "nickweiland@gmail.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.0.1"
end
