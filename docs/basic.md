# Basic Mode

The basic mode of the Snippet Extractor is extremely naive but works well to get you started.

A language config file contains a list of the beginnings of lines that can be ignored.
The extractor skips over all lines of code that start with a line that's in the config file.
Once the extract finds the first non-matching, it returns the next 10 lines, regardless if they match the config file or not.

Skipping code like HEREDOC and block comments, where there is not some marker on each line, is not supported.
Use the [Extended Mode](./extended.md) for those cases.
