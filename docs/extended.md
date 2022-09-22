# Extended Mode

This allows for more complex pattern and rules than the [Basic Mode](./basic.md).
It adds support for multiline and partial line rules.

It can be configured to only make modifications before the first non-matching code, or throughout the code.
In either scenario, it will return 10 lines of code.

## Usage

To enable these more advanced rules, add `!e` to the beginning of your language's config file.

For example:

```txt
!e

rule...
rule..
```

### Flags

You can pass extra flags at the beginning of the file to enable specific functionality.

There is currently one extra flag: `stop_at_first_loc`.

This flag forces the parse to immediately return the next 10 lines of code once it finds any line that is not stripped out.
By default, the extended parser will try to remove all comments from your code, but for many languages this produces too many false strips and so is problematic.

To use this, add `stop_at_first_loc` after the `!e`:

```txt
!e stop_at_first_loc

rule...
rule...
```

### Rules

As with the basic version, one rule is specified per line.
The extended version adds several modifiers that can be used to specify more advanced behaviour.

Unlike the basic version rules apply to anywhere within the line, not just a character at the start.
For example, the rule `#` would change the following:

```ruby
# Some comment
10 + 20 # Some other comment
```

to:

```ruby
# Some comment
Some
```

This can be problematic (consider that `#` is used for interpolation in Ruby), which is why you may want to use the `stop_at_first_loc` flag explained above.

### Basic Modifiers

The first set of rules handle how a token is found and dealt with.

As seen above, the most basic rule is adding a string that you want to match.
This will look for that string seperated from others by whitespace or line delimiters, and remove the matching string and anything that follows.

For example, given a config file such as...

```
!e
'
```

... and a snippet such as this...

```
' Delete me
Please ' delete me
I'm not deletable
```

... we would get the following output:

```
Please
I'm not deletable
```

To match without these whitespace restrictions we can use the `\p` modifier.
Changing the config to...

```
!e
'\p
```

would then result in:

```
Please
I
```

We can also choose to only remove the offending chars/strings using the `\j` modifier.
Changing the config to...

```
!e
'\j
```

would result in:

```
Delete me
Please delete me
I'm not deletable
```

And we can chain those modifiers together with config such as:

```
!e
'\pj
```

Which would result in (note the change in the bottom line):

```
Delete me
Please delete me
Im not deletable
```

This table summarises the examples above:

| Rule   | Requires whitespace | Removes subsequent chars |
| ------ | ------------------- | ------------------------ |
| `'`    | Yes                 | Yes                      |
| `'\p`  | No                  | Yes                      |
| `'\j`  | Yes                 | No                       |
| `'\pj` | No                  | No                       |

### Repeating Modifier

You can use an `+` after a character to mark it for `2..n` repetition.
This is useful for comment rules where a certain amount of symbols are allowed before another.

For example, if you want to match `/*****/` in Java, you could use the rule:

```text
!e
/*+/
```

Or in nim, if you wanted to match `###[...` you could use

```text
!e
#+[\p
```

These rules do **not** match the single version (they are `2..n`, not `1..n`) so please specify an extra explicit rule for the single scenario if needed.

### Multiline Magic Modifier

The real power of all these rules comes when the multiline modifer is added.

The multiline modifer is `-->>`.
It can be added between two rules to mark the rule as multiline.
All the text between the two rules will be skipped, plus all the text the end rule would skip normally.

For example...

```
!e
/*\p-->>*\p
```

would remove:

```csharp
/* This is a nice
mutliline
comment */
```

By combining with the `\j` flag, This works great for lines that have trailing characters too.
For example, adding th `\j` to the above rule rule...

```
!e
/*\p-->>*\pj
```

...with this code...

```javascript
/* This is a nice
mutliline
comment */ const n = 15;
```

would give us:

```javascript
const n = 15;
```

Rules precedence is calculated by earliest match.
This means that whole word rules usually have higher precedence, because they start matching from the preceding space.

## Examples

Each example has three blocks:

- Rules
- Input
- Ouput

### Example 1

```
!e
/*\p-->>?\*/\pj
```

```javascript
/*Some comment I wanted to add in case
that someone wants to read it*/def solve(data):
```

```javascript
def solve(data):
```

### Example 2

```
!e
import-->>from
```

```javascript
import {
 a,
 b,
 other
}
from 'example';

class Foobar...
```

```javascript
class Foobar...
```

### Example 3

```
!e
#+[-->>]#+
```

```nim
#[
 Doc
]#
###[More Doc]###

class Foobar...
```

```nim
class Foobar...
```

## FAQs

### Can I use a literal `\`?

Yes. `'\` is a valid rule and is the same as `'`.
For example: `\'\\` that will match with the string `\'\`

## Current limitations

All of these are open to future improvements if a track needs it, until we have the representers to back this up.

- Tabs are quirky.
  If you use a multiline comment which ends before a line which has actual code, the tabs will be ignored and the line will seem like wrongly indented.
  This is hard to fix without clotting a lot more the code and not something that will happen often enough to justify the work.
- As a rule of thumb, any rule clash will be not allowed unless there is a way to be totally sure of which one was intended.
- For any rules whose actual symbol / start actual symbol coincide, they'll be allowed if:
  - Simple rules: they need to use the same action (skip line, or skip just)
  - Multiline rules, they need to have the same start action. Their end rules will then be merged into the multiline end syntax tree
- A token repeat character at the beginning will throw an exception. There is nothing to repeat.

## Improvements

- We are able to support arguments supplying them after the `!e` in the first line.
  For example, not limiting ourselves to 10 lines. It might be useful to add extra meta functionality for specific tracks.
- Repeat character rule is quirky.
  Is the most painful in the code, but is needed for some languages.
  Leave it at is? Not? Disable it? Yada yada? Open to suggestions.
- Should we rstrip all saved lines of code?
  Right now I wanted to be safe and save them.
  It also had as a bonus that I could correctly asses matches and skipped in what I was expecting of.
  In the site they will be invisible, but I dunno.
  Opinions?
- Adding optional token syntax.
  It should avoid having to deal with many options for declaring something.
  Something like `@moduledoc [''',"""]\pj-->>[''',"""]\pj` but finding suitable and not conflicting delimiters could be hard.
  Implementation would be simple enough, just explode the options into all possible rules and then flat map the result of the rule parser on it.
  Which characters would make it easy and not conflicting to implement this?
- Add an option to specify an unmatchable rule that can be used to skip until the end of file in multiline rules.

## Closing thoughts

If you find something missing, please open an issue so we can check its inclusion.

**The representers will end substituting these parsers in the final launch, so please think of this as a "best effort"**
