# 📄 SimpleTextExtract

SimpleTextExtract attempts extract text from various file types and is recommended as a guard before resorting to something more extreme like Apache Tika. It is built specifically with ActiveStorage in mind and originally built for the purpose of extracting text from attachments in order to index the text in ElasticSearch using [SearchKick](https://github.com/ankane/searchkick).

SimpleTextExtract handles parsing text from:

- `.pdf`
- `.docx`
- `.doc`
- `.xlsx`
- `.xls`
- `.csv`
- `.txt` 😜

If no text is parsed (for `pdf`), or a file format is not supported (like images), then `nil` is returned and you can move on to the heavy-duty tools like [Henkei](https://github.com/abrom/henkei) 💪.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "simple_text_extract"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_text_extract

## Usage

Text can be parsed from raw file content or files in the filesystem t by calling `SimpleTextExtract.extract`:

```ruby
# using ActiveStorage >= 6
extract = attachment.open { |tmp| SimpleTextExtract.extract(tempfile: tmp) }
# raw file content or when ActiveStorage < 6
extract = SimpleTextExtract.extract(filename: attachment.blob.filename, raw: attachment.download)

# filesystem
extract = SimpleTextExtract.extract(filepath: "path_to_file.pdf")
```

### Usage Dependencies

You can choose to use SimpleTextExtract without the following dependencies, but it won't work for specific file types:

`pdf` parsing requires `poppler-utils`
- `brew install poppler`

`doc` parsing requires `antiword`
- `brew install antiword`

## Benchmarks

*Benchmarks test extracting text from the same file 50 times (Macbook pro)*

| File format | SimpleTextExtract | Henkei (i.e. Yomu/Apache Tika) |
|-------------|-------------------|--------------------------------|
| .doc        | 1.40s             | 74.27s                         |
| .docx       | 0.78s             | 71.44s                         |
| .pdf*       | 1.73s             | 82.86s                         |
| .xlsx       | 1.16s             | 51.89s                         |
| .xls        | 0.80s             | 67.88s                         |
| .txt        | 0.04s             | 39.25s                         |

* SimpleTextExtract is limited in its text extraction from pdfs, as Tika can also perform OCR on pdfs with Tesseract

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/simple_text_extract. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleTextExtract project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/simple_text_extract/blob/master/CODE_OF_CONDUCT.md).
