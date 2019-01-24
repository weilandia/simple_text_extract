# frozen_string_literal: true

module FastTextExtract
  class FileExtractor < TextExtractor
    attr_reader :filepath

    def initialize(filepath:)
      @filepath = filepath
    end

    private

      def file
        @file ||= File.new(filepath)
      end
  end
end
