# frozen_string_literal: true

require "simple_text_extract/format_extractor/base"
require "simple_text_extract/format_extractor/plain_text"
require "simple_text_extract/format_extractor/pdf"
require "simple_text_extract/format_extractor/xls_x"
require "simple_text_extract/format_extractor/xls"
require "simple_text_extract/format_extractor/doc_x"
require "simple_text_extract/format_extractor/doc"
require "simple_text_extract/format_extractor/zip_extract"

module SimpleTextExtract
  class FormatExtractorFactory
    def self.call(file)
      path = file.path
      filetype = path.split(".").last

      if SimpleTextExtract.cloud_support?(filetype:)
      end

      case file.path
      when /.zip$/i
        FormatExtractor::ZipExtract.new(file)
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
