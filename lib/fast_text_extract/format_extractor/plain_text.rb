# frozen_string_literal: true

module FastTextExtract
  module FormatExtractor
    class PlainText < Base
      def extract
        file.read
      end
    end
  end
end
