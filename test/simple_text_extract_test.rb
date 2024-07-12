# frozen_string_literal: true

require "test_helper"

class SimpleTextExtractTest < Minitest::Test
  def tempfile(path)
    raw = File.read(path)
    filename = path.split(".").then { |parts| [parts[0], ".#{parts[1]}"] }
    file = Tempfile.new(filename)

    file.write(raw)
    file.tap(&:rewind)
  end

  def test_that_it_has_a_version_number
    refute_nil ::SimpleTextExtract::VERSION
  end

  def test_supports
    assert SimpleTextExtract.supports?(filename: "example.xls")
    assert SimpleTextExtract.supports?(filename: "example.xlsx")
    assert SimpleTextExtract.supports?(filename: "example.docx")
    assert SimpleTextExtract.supports?(filename: "example.doc")
    assert SimpleTextExtract.supports?(filename: "example.pdf")
    assert SimpleTextExtract.supports?(filename: "example.txt")
    assert SimpleTextExtract.supports?(filename: "example.zip")

    refute SimpleTextExtract.supports?(filename: "example.jpg")
    refute SimpleTextExtract.supports?(filename: "example.png")
    refute SimpleTextExtract.supports?(filename: "example.whatever")
  end

  def test_it_parses_txt_files_to_text_from_path
    assert_equal File.read("test/fixtures/test_txt.txt").strip, SimpleTextExtract.extract(filepath: "test/fixtures/test_txt.txt")
  end

  def test_it_parses_txt_files_to_text_from_raw
    assert_equal File.read("test/fixtures/test_txt.txt").strip, SimpleTextExtract.extract(filename: "test_txt.txt", raw: File.read("test/fixtures/test_txt.txt"))
  end

  def test_it_parses_txt_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_txt.txt"))
    assert_equal File.read("test/fixtures/test_txt.txt").strip, result
  end

  def test_it_parses_doc_files_to_text_from_path
    assert_includes SimpleTextExtract.extract(filepath: "test/fixtures/test_doc.doc"), "This is a regular paragraph with the default style of Normal."
  end

  def test_it_parses_doc_files_to_text_from_raw
    assert_includes SimpleTextExtract.extract(filename: "test_doc.doc", raw: File.read("test/fixtures/test_doc.doc")), "This is a regular paragraph with the default style of Normal."
  end

  def test_it_parses_doc_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_doc.doc"))
    assert_includes result, "This is a regular paragraph with the default style of Normal."
  end

  def test_it_parses_doc_files_with_invalid_byte_sequence
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/invalid_byte_sequence.doc"))
    assert_includes result, "State Corporation Commission"
  end

  def test_it_parses_docx_files_to_text_from_path
    assert_equal "Test\nLine 3", SimpleTextExtract.extract(filepath: "test/fixtures/test_docx.docx")
  end

  def test_it_parses_docx_files_to_text_from_raw
    assert_equal "Test\nLine 3", SimpleTextExtract.extract(filename: "test_docx.docx", raw: File.read("test/fixtures/test_docx.docx"))
  end

  def test_it_parses_docx_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_docx.docx"))
    assert_equal "Test\nLine 3", result
  end

  def test_it_parses_tables_in_docx_files
    expected = "QTY, Item Name\n0, Row 1\n1, Row 2\n2, Row 3\n3, Row 4\n4, Row 5\n5, Row 6\n6, Row 7\n7, Row 8"
    assert_equal expected, SimpleTextExtract.extract(filepath: "test/fixtures/text_docx_alt.docx")
  end

  def test_it_parses_pdf_files_to_text_from_path
    assert_includes SimpleTextExtract.extract(filepath: "test/fixtures/test_pdf.pdf"), "This is a small demonstration .pdf file"
  end

  def test_it_parses_pdf_files_to_text_from_raw
    assert_includes SimpleTextExtract.extract(filename: "test_pdf.pdf", raw: File.read("test/fixtures/test_pdf.pdf")), "This is a small demonstration .pdf file"
  end

  def test_it_parses_pdf_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_pdf.pdf"))
    assert_includes result, "This is a small demonstration .pdf file"
  end

  def test_it_parses_xlsx_files_to_text_from_path
    result = SimpleTextExtract.extract(filepath: "test/fixtures/test_xlsx.xlsx")

    assert_includes "# Sheet Index: 0\n# Sheet Name: Sheet1\nruby 25\n# Sheet Index: 1\n# Sheet Name: Sheet2\njs 35", result

    assert_equal "", SimpleTextExtract.extract(tempfile: Tempfile.new(["", "blank.xlsx"]))
  end

  def test_it_parses_xlsx_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_xlsx.xlsx"))

    assert_equal "# Sheet Index: 0\n# Sheet Name: Sheet1\nruby 25\n# Sheet Index: 1\n# Sheet Name: Sheet2\njs 35", result
  end

  def test_it_parses_xlsx_files_to_text_from_raw_excludes_hidden
    result = SimpleTextExtract.extract(filename: "test_xlsx.xlsx", raw: File.read("test/fixtures/test_xlsx.xlsx"))

    assert_equal "# Sheet Index: 0\n# Sheet Name: Sheet1\nruby 25\n# Sheet Index: 1\n# Sheet Name: Sheet2\njs 35", result
  end

  def test_it_parses_xlsx_files_to_text_with_complex_text
    result = SimpleTextExtract.extract(filename: "test_xlsx.xlsx", raw: File.read("test/fixtures/test_file_with_complex_text.xlsx"))
    assert result.include?("Pricing Template")
  end

  def test_nil_to_integer
    result = SimpleTextExtract.extract(filename: "roo_bad_link.xlsx", raw: File.read("test/fixtures/roo_bad_link.xlsx"))

    assert_equal "# Sheet Index: 0\n# Sheet Name: bad_link\nTest", result
  end

  def test_it_parses_xls_files_to_text_from_path
    assert_includes SimpleTextExtract.extract(filepath: "test/fixtures/test_xls.xls"), "What C datatypes are 8 bits? (assume i386)"
  end

  def test_it_parses_xls_files_to_text_from_raw
    assert_includes SimpleTextExtract.extract(filename: "test_xls.xls", raw: File.read("test/fixtures/test_xls.xls")), "What C datatypes are 8 bits? (assume i386)"
  end

  def test_it_parses_xls_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_xls.xls"))
    assert_includes result, "What C datatypes are 8 bits? (assume i386)"
  end

  def test_it_parses_zip_files_to_text_from_raw
    result = SimpleTextExtract.extract(filename: "test_zip.zip", raw: File.read("test/fixtures/test_zip.zip"))

    assert_includes result, "What C datatypes are 8 bits? (assume i386)"
    assert_includes result, File.read("test/fixtures/test_txt.txt").strip
  end

  def test_it_parses_zip_files_to_text_from_tempfile
    result = SimpleTextExtract.extract(tempfile: tempfile("test/fixtures/test_zip.zip"))

    assert_includes result, "What C datatypes are 8 bits? (assume i386)"
    assert_includes result, File.read("test/fixtures/test_txt.txt")
  end

  def test_it_returns_empty_if_filetype_not_supported
    ["test_jpg.jpg", "test_png.png"].each do |filename|
      assert_empty SimpleTextExtract.extract(filepath: "test/fixtures/#{filename}")

      assert_empty SimpleTextExtract.extract(filename:, raw: File.read("test/fixtures/#{filename}"))
    end
  end

  def test_returns_empty_if_nothing_passed_in
    assert_empty SimpleTextExtract.extract
  end

  def test_returns_empty_if_nonsense_is_passed_in
    assert_empty SimpleTextExtract.extract(filepath: "dksld/fkjlds.txt")
    assert_empty SimpleTextExtract.extract(filepath: "dksld")
    assert_empty SimpleTextExtract.extract(filename: "dksld.ppt", raw: "fkldsj")
  end

  def test_returns_empty_when_dependencies_not_present
    SimpleTextExtract.stubs(:missing_dependency?).returns(true)

    assert_empty SimpleTextExtract.extract(filepath: "test/fixtures/test_doc.doc")
    assert_empty SimpleTextExtract.extract(filepath: "test/fixtures/test_pdf.pdf")
  end
end
