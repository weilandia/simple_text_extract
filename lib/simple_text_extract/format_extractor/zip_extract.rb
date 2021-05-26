# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class ZipExtract < Base
      def extract
        require "zip"

        result = []
        Zip::File.open(file) do |zip_file|
          zip_file.each do |entry|
            result << entry.name
            result << SimpleTextExtract.extract(
              raw: entry.get_input_stream.read,
              filename: entry.name
            )
          end
        end

        result.join(" ")
      end
    end
  end
end
