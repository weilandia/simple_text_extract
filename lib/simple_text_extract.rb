# frozen_string_literal: true

require "simple_text_extract/version"
require "simple_text_extract/extract"

module SimpleTextExtract
  SUPPORTED_FILETYPES = ["xls", "xlsx", "doc", "docx", "txt", "pdf", "csv", "zip"].freeze

  class Error < StandardError; end

  def self.extract(filename: nil, raw: nil, filepath: nil, tempfile: nil)
    Extract.new(filename:, raw:, filepath:, tempfile:).to_s
  end

  def self.supports?(filename: nil)
    SUPPORTED_FILETYPES.include?(filename.to_s.split(".").last)
  end

  def self.missing_dependency?(command)
    dependency = `sh -c 'command -v #{command}'`
    dependency.nil? || dependency.empty?
  end
end
