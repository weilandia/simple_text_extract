# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class Doc < Base
      def extract
        return nil if missing_dependency?('antiword')

        `antiword #{Shellwords.escape(file.path)}`
      end
    end
  end
end
