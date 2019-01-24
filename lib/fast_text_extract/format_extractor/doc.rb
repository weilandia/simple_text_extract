# frozen_string_literal: true

module FastTextExtract
  module FormatExtractor
    class Doc < Base
      def extract
        `antiword #{Shellwords.escape(file.path)}`
      end
    end
  end
end
