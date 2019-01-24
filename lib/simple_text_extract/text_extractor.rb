# frozen_string_literal: true

module SimpleTextExtract
  class TextExtractor
    def self.call(filename: nil, raw: nil, filepath: nil)
      if !filename.nil? && !raw.nil?
        TempfileExtractor.new(filename: filename.to_s, raw: raw.force_encoding("UTF-8")).extract
      elsif !filepath.nil? && File.exist?(filepath)
        FileExtractor.new(filepath: filepath).extract
      end
    end

    def extract
      text = FormatExtractorFactory.call(file).extract
      cleanup

      text
    end

    private

      def cleanup
      end
  end
end
