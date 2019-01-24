# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class XlsX < Base
      def extract
        return nil if missing_dependency?("ssconvert")

        extract_filepath = "#{file.path.split(".")[0]}.txt"

        `ssconvert -O 'separator=" "' #{Shellwords.escape(file.path)} #{extract_filepath}`

        text = File.read(extract_filepath)
        File.unlink(extract_filepath)

        text
      end
    end
  end
end
