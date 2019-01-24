# frozen_string_literal: true

module FastTextExtract
  class TempfileExtractor < TextExtractor
    attr_reader :filename, :raw

    def initialize(filename:, raw:)
      @filename = filename
      @raw = raw

      write_raw
    end

    private

      def file
        @file ||= Tempfile.new(filepath)
      end

      def write_raw
        file.write(raw)
        file.rewind
      end

      def cleanup
        file.unlink
      end

      def filepath
        @filepath ||= filename.split(".").yield_self { |parts| [parts[0], ".#{parts[1]}"] }
      end
  end
end
