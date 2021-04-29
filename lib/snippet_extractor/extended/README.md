# Extended snipper extractor

### Usage

Just put `!e` at the beginning of your language's .txt file to read the file using the extended version.

The extended version adds syntax to the txt file to allow more complex removals (mid file and multiline)
using multiline and partial line rules.

It will then retrieve the first 10 lines of remaining code.

### Syntax

`id` means any string. The strings are matched regardless of case. 
The only reserved character is `+`. If for some language this gives any problems, please open an issue so we can look
into other options.

The txt file is divided in several rules, one for each line. Every rule has a different behaviour. Please see the below
table for the different rules and what they'll match.

* Rule -> The syntax a line should have to apply that rule. For every rule, the example `id` will be used
* Matches completely -> Matches on entire word, or for any occurrence. A word here is any string separated by spaces.
* Skips line -> If the match skips the entire line from the match until the next, or if it only ignores up from/until the match.
* Example -> Example of strings that will match. a pair of brackets `[]` will mark what is skipped.

|  Rule  |  Matches completely  |    Skips line   |  Example                               | Comment                                                                        |
|--------|----------------------|-----------------|----------------------------------------|--------------------------------------------------------------------------------|
|  `id`  |         Yes          |        Yes      | List [**id** lists 4 3 2 ;]            | The default. It matches to ` id ` with the spaces (spaces can be any `strip`able char).                                                                  |
| `id\p` |         No           |        Yes      | var [**id**entifier car A car]         | For symbols that can be used without spaces like `/*a*/`                       |
| `id\j` |         Yes          |        No       | var resume; List [**id**] lists 4 3 2 ;| For symbols that can be put mid sentence. Better used with multiline rule.     |
| `id\pj`|         No           |        No       | var [**id**]entifier car A car         | Useful for cases like `/*This is an int*/int sum=0;`

Note: `id\ ` is a valid rule and is the same as `id`. You can use that if you need a rule that needs to use `\ ` character,
for example: `\id\\` that will match with the string `\id\ `

* Character repeating rule -> Add + after a character to mark it for 2..n repetition. Useful for comment rules like
`#+[` that will match `##[` and `#####[`. WILL NOT match `#[` so use another rule for that specific scenario

* Multiline rule -> Add -->> between two rules to mark the rule as multiline. All the text between the two rules will be skipped,
plus all the text the end rule would skip normally.
  
* Rules precedence is by earliest match. This also means that whole word rules usually have higher precedence, because
they start matching from the preceding space.
  
Some examples:

* 
Rule:  
`/*\p-->>?*/\pj`

On:
```
/*Some comment I wanted to add in case 
that someone wants to read it*/def solve(data):
```

Result:
```
def solve(data):
```

* 
Rule:
`import-->>from`

On:
```
import {
 a,
 b,
 other
}
from 'example';
```

Result:
*empty*

*
Rule:
`#+[-->>]#+`

On:
```
#[
 Doc
]#
###[More Doc]###
```

Result: *empty* 

### Current limitations 

All of these are open to future improvements if a track needs it, until we have the representers to back this up.

* Tabs are quirky. If you use a multiline comment which ends before a line which has actual code, the tabs will
  be ignored and the line will seem like wrongly indented. Is QUITE hard to fix without clotting a lot more the code
  and I don't think is something that will happen often, if at all.

####Not allowed rule combinations
* As a rule of thumb, any rule clash will be not allowed unless there is a way to be totally sure of which one
  should be picked.
* For any rules whose actual id/start actual id coincide, they'll be allowed if:
  * Simple rules: they need to use the same action (skip line, or skip just)
  * Multiline rules, they need to have the same start action. Their end rules will then be merged into the multiline
    end syntax tree
* A token repeat character at the beginning will throw an exception. There is nothing to repeat.

# Improvements

* We are able to support arguments supplying them after the `!e` in the first line. For example, not limiting
  ourselves to 10 lines. It might be useful to add extra meta functionality for specific tracks.
* Repeat character rule is quirky. Is the most painful in the code, but is needed for some languages. Leave it at is? 
  Not? Disable it? Yada yada? Open to suggestions.
* Should we rstrip all saved lines of code? Right now I wanted to be safe and save them. It also had as a bonus that I
  could correctly asses matches and skipped in what I was expecting of. In the site they will be invisible, but I dunno.
  Opinions?
* Adding optional token syntax. It should avoid having to deal with many options for declaring something.
  Something like `@moduledoc [''',"""]\pj-->>[''',"""]\pj` but finding suitable and not conflicting delimiters could be 
  hard. Implementation would be simple enough, just explode the options into all possible rules and then flat map the
  result of the rule parser on it. Which characters would make it easy and not conflicting to implement this?
* Add an option to specify an unmatchable rule that can be used to skip until the end of file in multiline rules.

**If you find something missing, please open an issue so we can check its inclusion**

**The representers will end substituting these parsers in the final launch, so please think of this as a "best effort"**