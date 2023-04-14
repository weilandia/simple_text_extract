## 2.0.0 (2023-04-14)

- [BREAKING CHANGE] Improves format of text extracts to better support post processing into sentences/rows. This will only cause issues if you have tests/code that relies on the specific format of whitespace characters in the resulting extracts. For example, the docx extract will now preserve newline characters.
- Improves memory allocation for xlsx files using `Roo#each_row_streaming`
- Adds github actions as ci
- Simplifies private api away from individual "format extractors"
