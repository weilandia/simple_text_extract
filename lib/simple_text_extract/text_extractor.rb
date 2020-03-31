# frozen_string_literal: true

module SimpleTextExtract
  class TextExtractor
    attr_reader :file

    def initialize(filename: nil, raw: nil, filepath: nil, tempfile: nil)
      @file = get_file(filename: filename, raw: raw, filepath: filepath, tempfile: tempfile)
    end

    def to_s
      @to_s ||= extract.to_s
    end

    private

      def get_file(filename:, raw:, filepath:, tempfile:)
        if tempfile&.class == Tempfile
          tempfile
        elsif !filename.nil? && !raw.nil?
          write_tempfile(filename: filename.to_s, raw: raw)
        elsif !filepath.nil? && File.exist?(filepath)
          File.new(filepath)
        end
      end

      def extract
        return unless file

        begin
          FormatExtractorFactory.call(file).extract
        ensure
          cleanup
        end
      end

      def cleanup
        return unless file.class == Tempfile

        file.close
        file.unlink
      end

      def write_tempfile(filename:, raw:)
        filename = filename.split(".").yield_self { |parts| [parts[0], ".#{parts[1]}"] }
        file = Tempfile.new(filename)
        raw = String.new(raw, encoding: Encoding::UTF_8)

        file.write(raw)
        file.tap(&:rewind)
      end
  end
end
