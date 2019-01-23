# frozen_string_literal: true

require "fast_text_extract/version"

module FastTextExtract
  class Error < StandardError; end

  def self.extract(filename: nil, raw_content: nil, filepath: nil)
    FastTextExtract::TextExtractor.call(filename: filename, raw_content: raw_content, filepath: filepath)
  end
end
