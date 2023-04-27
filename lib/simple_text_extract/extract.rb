# frozen_string_literal: true

class SimpleTextExtract::Extract # rubocop:disable Metrics/ClassLength
  def self.formatter(path)
    case path
    when /.zip$/i
      :zip
    when /(.txt$|.csv$)/i
      :plain
    when /.pdf$/i
      :pdf
    when /.docx$/i
      :docx
    when /.doc$/i
      :doc
    when /.xlsx$/i
      :xlsx
    when /.xls$/i
      :xls
    end
  end

  attr_reader :file, :formatter

  def initialize(filename: nil, raw: nil, filepath: nil, tempfile: nil)
    @file = get_file(filename:, raw:, filepath:, tempfile:)
    @formatter = self.class.formatter(File.extname(file)) if file
  end

  def to_s
    @to_s ||= extract.to_s.gsub(/[^\S\n]+/, " ").gsub(/\s?\n\s+/, "\n").strip
  end

  private

    def get_file(filename:, raw:, filepath:, tempfile:)
      if tempfile&.class == Tempfile
        tempfile
      elsif !filename.nil? && !raw.nil?
        write_tempfile(filename: filename.to_s, raw:)
      elsif !filepath.nil? && File.exist?(filepath)
        File.new(filepath)
      end
    end

    def extract
      return unless file

      begin
        send("#{formatter}_extract") if formatter
      rescue StandardError
        nil
      ensure
        cleanup
      end
    end

    def cleanup
      return unless file.instance_of?(Tempfile)

      file.close
      file.unlink
    end

    def write_tempfile(filename:, raw:)
      filename = filename.split(".").then { |parts| [parts[0], ".#{parts[1]}"] }
      file = Tempfile.new(filename)
      raw = String.new(raw, encoding: Encoding::UTF_8)

      file.write(raw)
      file.tap(&:rewind)
    end

    def plain_extract
      file.read
    end

    def pdf_extract
      return nil if SimpleTextExtract.missing_dependency?("pdftotext")

      `pdftotext #{Shellwords.escape(file.path)} -`
    end

    def xlsx_extract
      require "roo"

      spreadsheet = Roo::Spreadsheet.open(file, only_visible_sheets: true)

      text = []

      spreadsheet.sheets.each_with_index do |name, i|
        text << "# Sheet Index: #{i}"
        text << "# Sheet Name: #{name}"

        spreadsheet.sheet(name)&.each_row_streaming do |row|
          text << row.filter(&:present?).join(" ")
        end
      end

      text.join("\n")
    end

    def xls_extract
      require "spreadsheet"

      spreadsheet = Spreadsheet.open(file)
      text = []
      spreadsheet.worksheets.each do |sheet|
        text << sheet.name
        sheet.rows.each { |row| text << row.join(" ") }
      end

      text.join("\n")
    end

    def doc_extract
      return nil if SimpleTextExtract.missing_dependency?("antiword")

      `antiword #{Shellwords.escape(file.path)}`
    end

    def docx_extract
      require "zip"
      require "nokogiri"

      result = []
      Zip::File.open(file) do |zip_file|
        document = zip_file.glob("word/document*.xml").first
        return "" if document.nil?

        document_xml = document.get_input_stream.read
        doc = Nokogiri::XML(document_xml)
        doc.xpath("//w:document//w:body/w:p").each do |node|
          result << node.text
        end

        doc.xpath("//w:document//w:body//w:tbl").each do |node|
          node.xpath(".//w:tr").each do |row|
            text = row.xpath("w:tc").map(&:text)
            result << text.join(", ")
          end
        end
      end

      result.join("\n")
    end

    def zip_extract
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

      result.join("\n")
    end
end
