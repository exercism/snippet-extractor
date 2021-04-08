# Exercism's Generic Snippet Extractor

![Tests](https://github.com/exercism/generic-snippet-extractor/workflows/Tests/badge.svg)

This is Exercism's generic snippet extractor.
It takes an exercism submission and extracts the first ten "interesting" lines of code.

## Add your language

Each language has a file inside `lib/languages` with the filename `$slug.txt` - for example: `lib/lanugages/ruby.txt`.

A language file contains a list of the beginnings of lines that can be ignored.
The extractor skips over all lines of code that start with a line on the `$lang.txt` file, until it finds the first non-matching, at which point it takes the next 10 lines.
Things like HEREDOC and block comments where there is not some marker on each line are not currently supported.

Along with each language file is a test file in `test/languages/$slug_test.rb`.
When adding or making changes to a language file, please add or update the corresponding language file, copying `ruby_test.rb` as your basis.
At a minimum all references to "ruby" (case insensitive) should be changed to the slug of your language - searching for these is a good way to start.

Ruby, PHP and C# all contain good examples of different of different things that could be skipped and are good files to look at.

## Running the tests

You can run the tests locally or rely on the CI to test things for you (it's fast).

The repo relies on Ruby 2.6.6.
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
