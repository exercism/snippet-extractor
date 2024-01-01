# Exercism's Snippet Extractor

![Tests](https://github.com/exercism/snippet-extractor/workflows/Tests/badge.svg)

This is Exercism's snippet extractor.
It takes an exercism submission and extracts the first ten "interesting" lines of code.

## Add your language

Each language has a config file inside `lib/languages` with the filename `$slug.txt` - for example: `lib/languages/ruby.txt`.

Each file can be in [Basic Mode](docs/basic.md) or [Extended Mode](docs/extended.md).
Please read those docs to choose which to use for your language.

Along with each language file is a test file in `test/languages/$slug_test.rb`.
When adding or making changes to a language file, please add or update the corresponding language file, copying `ruby_test.rb` as your basis.
At a minimum all references to "ruby" (case insensitive) should be changed to the slug of your language - searching for these is a good way to start.

Ruby, PHP and C# all contain good examples of different of different things that could be skipped and are good files to look at.

### Slugs with hyphens

For slugs with hyphens, check out `common-lisp` as your example.

## Running the tests

You can run the tests locally or rely on the CI to test things for you (it's fast).

The repo relies on Ruby 3.2.0.
Before running the tests, first install the dependencies:

```bash
bundle install
```

Then, run the following command to run the tests:

```bash
bundle exec rake test
```

To only run the tests in a single test file, add `TEST=<relative-path-to-test-file>`:

```bash
bundle exec rake test TEST=test/languages/csharp_test.rb
```

## Credit

This repo is built and maintained by Exercism.

The initial spike of this was written by [Jeremy Walker](https://github.com/ihid).
The extended version was written by [José Ráez Rodríguez](https://github.com/joshiraez).

Contributions are welcome!
