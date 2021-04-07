# Exercism's Ruby Representer

![Tests](https://github.com/exercism/generic-snippet-extractor/workflows/Tests/badge.svg)

This is Exercism's generic snippet extractor. 
It takes an exercism submission and extracts the first 10 interesting lines of code.

It is run with `./bin/run.sh $LANGUAGE_SLUG $PATH_TO_FILES $PATH_FOR_OUTPUT` and will read the source code from `$PATH_TO_FILES` and write a text file with a snippet to `$PATH_FOR_OUTPUT`.

For example:

```bash
./bin/run.sh ruby ~/submission-238382y7sds7fsadfasj23j/ ~/submission-238382y7sds7fsadfasj23j/output
```

## Running the tests

Before running the tests, first install the dependencies:

```bash
bundle install
```

Then, run the following command to run the tests:

```bash
bundle exec rake test
```
