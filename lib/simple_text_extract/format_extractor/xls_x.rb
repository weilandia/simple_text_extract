# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class XlsX < Base
      def extract
        require 'creek'
        creek = Creek::Book.new(file)
        text = []

        creek.sheets.each do |sheet|
          next if sheet.state == 'hidden'

          text << sheet.name
          sheet.rows.each { |row| text << row.values }
        end

        text.flatten.join(" ")
      end
    end
  end
end
