# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class Doc < Base
      def extract
        return nil if `command -v antiword`.empty?

        `antiword #{Shellwords.escape(file.path)}`
      end
    end
  end
end
