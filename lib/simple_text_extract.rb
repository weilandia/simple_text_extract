# frozen_string_literal: true

require "simple_text_extract/version"
require "simple_text_extract/text_extractor"
require "simple_text_extract/file_extractor"
require "simple_text_extract/tempfile_extractor"
require "simple_text_extract/format_extractor_factory"

module SimpleTextExtract
  class Error < StandardError; end

  def self.extract(filename: nil, raw: nil, filepath: nil)
    TextExtractor.call(filename: filename, raw: raw, filepath: filepath).to_s
  end
end
