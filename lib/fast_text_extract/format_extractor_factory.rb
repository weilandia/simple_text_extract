# frozen_string_literal: true

require "fast_text_extract/format_extractor/base"
require "fast_text_extract/format_extractor/plain_text"
require "fast_text_extract/format_extractor/pdf"
require "fast_text_extract/format_extractor/doc_x"
require "fast_text_extract/format_extractor/doc"

module FastTextExtract
  class FormatExtractorFactory
    def self.call(file)
      case file.path
      when /.txt$/i
        FormatExtractor::PlainText.new(file)
      when /.pdf$/i
        FormatExtractor::PDF.new(file)
      when /.docx$/i
        FormatExtractor::DocX.new(file)
      when /.doc$/i
        FormatExtractor::Doc.new(file)
      end
    end
  end
end
