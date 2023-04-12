# frozen_string_literal: true

require "simple_text_extract/version"
require "simple_text_extract/text_extractor"
require "simple_text_extract/format_extractor_factory"

module SimpleTextExtract
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    NATIVE_SUPPORTED_FILETYPES = ["xls", "xlsx", "doc", "docx", "txt", "pdf", "csv", "zip"].freeze
    CLOUD_SUPPORTED_FILETYPES = ["pdf", "png", "jpeg", "tiff"].freeze

    attr_accessor :cloud_extract_filetypes, :aws_credentials

    def initialize
      @native_extract_filetypes = ["xls", "xlsx", "doc", "docx", "txt", "pdf", "csv", "zip"]
      @cloud_extract_filetypes = []
    end
  end

  def self.extract(filename: nil, raw: nil, filepath: nil, tempfile: nil)
    TextExtractor.new(filename:, raw:, filepath:, tempfile:).to_h
  end

  def self.supports?(filename:)
    filetype = filename.split(".").last
    native_support?(filetype:) || cloud_support?(filetype:)
  end

  def self.native_support?(filetype:)
    NATIVE_SUPPORTED_FILETYPES.include?(filetype) && configuration.native_extract_filetypes.include?(filetype)
  end

  def self.cloud_support?(filetype:)
    CLOUD_SUPPORTED_FILETYPES.include?(filetype) && configuration.cloud_extract_filetypes.include?(filetype)
  end
end
