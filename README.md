# Exercism's Ruby Representer

![Tests](https://github.com/exercism/generic-snippet-extractor/workflows/Tests/badge.svg)

This is Exercism's generic snippet extractor. 
It takes an exercism submission and extracts the first 10 interesting lines of code.

## Add your language

Each language has a file inside `lib/languages` with the filename `$slug.txt` - for example: `lib/lanugages/ruby.txt`.

A language file contains a list of the beginnings of lines that can be ignored.
The extractor skips over all lines that match the ones in this file until it finds the first non-matching.

Along with each language file is a test file in `lib/languages/$slug_test.rb`. 
When adding or making changes to a language file, please add or update the corresponding language file, copying `ruby_test.rb` as your basis.

## Running the tests

Before running the tests, first install the dependencies:

```bash
bundle install
```

Then, run the following command to run the tests:

```bash
bundle exec rake test
```
