# frozen_string_literal: true

module SimpleTextExtract
  module FormatExtractor
    class XlsX < Base
      def extract
        require "roo"

        spreadsheet = Roo::Spreadsheet.open(file, only_visible_sheets: true)

        text = []

        spreadsheet.each_with_pagename do |name, sheet|
          text << name
          1.upto(sheet.last_row.to_i) { |row| text << sheet.row(row) }
        end

        text.flatten.join(" ")
      end
    end
  end
end
