# frozen_string_literal: true

require "simple_text_extract/format_extractor/base"
require "simple_text_extract/format_extractor/plain_text"
require "simple_text_extract/format_extractor/pdf"
require "simple_text_extract/format_extractor/xls_x"
require "simple_text_extract/format_extractor/xls"
require "simple_text_extract/format_extractor/doc_x"
require "simple_text_extract/format_extractor/doc"

module SimpleTextExtract
  class FormatExtractorFactory
    def self.call(file) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
      case file.path
      when /(.txt$|.csv$)/i
        FormatExtractor::PlainText.new(file)
      when /.pdf$/i
        FormatExtractor::PDF.new(file)
      when /.docx$/i
        FormatExtractor::DocX.new(file)
      when /.doc$/i
        FormatExtractor::Doc.new(file)
      when /.xlsx$/i
        FormatExtractor::XlsX.new(file)
      when /.xls$/i
        FormatExtractor::Xls.new(file)
      else
        FormatExtractor::Base.new(file)
      end
    end
  end
end
