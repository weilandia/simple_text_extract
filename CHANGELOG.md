## 3.0.1 (2023-04-17)

- Coerces filename in `SimpleTextExtract.supports?(filename:)` to string.

## 3.0.1 (2023-04-17)

- Fixes printing of Roo::Excelx::Cell::Empty for empty rows

## 3.0.0 (2023-04-14)

- [BREAKING CHANGE] Improves format of text extracts to better support post processing into sentences/rows. This will only cause issues if you have tests/code that relies on the specific format of whitespace characters in the resulting extracts. For example, the docx extract will now preserve newline characters.
- Improves memory allocation for xlsx files using `Roo#each_row_streaming`
- Adds github actions as ci
- Simplifies private api away from individual "format extractors"
