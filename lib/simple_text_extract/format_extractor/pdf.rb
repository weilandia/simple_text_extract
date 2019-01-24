# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class PDF < Base
      def extract
        return nil if `command -v pdftotext`.empty?

        `pdftotext #{Shellwords.escape(file.path)} -`
      end
    end
  end
end
