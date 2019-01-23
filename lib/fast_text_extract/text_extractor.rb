# frozen_string_literal: true

class FastTextExtract::TextExtractor
  def self.call(filename:, raw_content:, filepath:)
    new(filename: filename, raw_content: raw_content, filepath: filepath).extract
  end

  attr_reader :filename, :raw_content, :filepath

  def initialize(filename:, raw_content:, filepath:)
    @filename = filename
    @raw_content = raw_content
    @filepath = filepath
  end

  def extract
    
  end
end
