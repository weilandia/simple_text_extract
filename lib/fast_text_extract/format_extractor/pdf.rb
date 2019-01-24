# frozen_string_literal: true

module FastTextExtract
  module FormatExtractor
    class PDF < Base
      def extract
        `pdftotext #{Shellwords.escape(file.path)} -`
      end
    end
  end
end
