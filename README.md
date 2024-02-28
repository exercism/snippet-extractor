# Exercism's Snippet Extractor

![Tests](https://github.com/exercism/snippet-extractor/workflows/Tests/badge.svg)

This is Exercism's snippet extractor.
It takes the code of an Exercism submission and creates a snippet for it (shown on various places on the website).

## Customizing snippet extraction

By default, the snippet extractor extracts the first ten "interesting" (non-empty) lines of code.
Whilst the default behavior is useful, we recommend customing snippet generation for most languages.

### Customization

The most common customization is to ignore comments, but you might also want to ignore:

- Imports/exports
- Namespace/module declarations

### Add configuration

To customize snippet extraction, start by creating a config file for your language at `lib/languages/<slug>.txt` (e.g. `lib/languages/ruby.txt`).
This file will define the rules used by the snippet extractor to select the lines of code included in generated snippets.

Your configuration file can be in two modes, which influence what you can do in your config file:

- [Basic Mode](docs/basic.md)
- [Extended Mode](docs/extended.md).

Please read those docs to determine which to use for your language.

### Add golden tests

To verify the configuration, one or more [golden tests][golden] should be added to `tests/<slug>`.
Each test is defined in its own directory (e.g. `tests/ruby/full`) and must contain two files:

- `code.<extension>`: the code to create the snippet from
- `expected_snippet.<extension>`: the expected snippet

You can then run the tests for your language via:

```shell
LANGUAGE=<slug> bundle exec rake test TEST=test/languages_test.rb
```

As an example, here's how to run the tests for ruby:

```shell
LANGUAGE=ruby bundle exec rake test TEST=test/languages_test.rb
```

### Inspiration

We recommend looking at how existing languages have defined their config and tests, which you could probably use as a starting point.
Ruby, PHP and C# all contain good starting points.

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

## Credit

This repo is built and maintained by Exercism.

The initial spike of this was written by [Jeremy Walker](https://github.com/ihid).
The extended version was written by [José Ráez Rodríguez](https://github.com/joshiraez).

Contributions are welcome!

[golden]: https://ro-che.info/articles/2017-12-04-golden-tests
