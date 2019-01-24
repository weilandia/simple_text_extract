# frozen_string_literal: true

require "fast_text_extract/version"
require "fast_text_extract/text_extractor"
require "fast_text_extract/file_extractor"
require "fast_text_extract/tempfile_extractor"
require "fast_text_extract/format_extractor_factory"

module FastTextExtract
  class Error < StandardError; end

  def self.extract(filename: nil, raw: nil, filepath: nil)
    TextExtractor.call(filename: filename, raw: raw, filepath: filepath)
  end
end
