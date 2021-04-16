# Extended snipper extractor

### Usage

Just put `!e` at the beginning of your language's .txt file to read the file using the extended version.

The extended version adds syntax to the txt file to allow more complex removals (mid file and multiline)
using multiline and partial line rules.

It will then retrieve the first 10 lines of remaining code.

### Syntax

`id` means any string. The only reserved character is `+`. If for some language this gives any problems, please open an 
issue so we can look into other options.

The txt file is divided in several rules, one for each line. Every rule has a different behaviour. Please see the below
table for the different rules and what they'll match.

* Rule -> The syntax a line should have to apply that rule. For every rule, the example `id` will be used
* Matches completely -> Matches on entire word, or for any occurrence. A word here is any string separated by spaces.
* Skips line -> If the match skips the entire line from the match until the next, or if it only ignores up from/until the match.
* Example -> Example of strings that will match. a pair of brackets `[]` will mark what is skipped.

|  Rule  |  Matches completely  |    Skips line   |  Example                               | Comment                                                                        |
|--------|----------------------|-----------------|----------------------------------------|--------------------------------------------------------------------------------|
|  `id`  |         Yes          |        Yes      | List [**id** lists 4 3 2 ;]            | The default                                                                    |
| `id\p` |         No           |        Yes      | var [**id**entifier car A car]         | For symbols that can be used without spaces like `/*a*/`                       |
| `id\j` |         Yes          |        No       | var resume; List [**id**] lists 4 3 2 ;| For symbols that can be put mid sentence. Better used with multiline rule.     |
| `id\pj`|         No           |        No       | var [**id**]entifier car A car         | Useful for cases like `/*This is an int*/int sum=0;`

Note: `id\ ` is a valid rule and is the same as `id`. You can use that if you need a rule that needs to use `\ ` character,
for example: `\id\\` that will match with the string `\id\ `

* Character repeating rule -> Add + after a character to mark it for 1..n repetition. Useful for comment rules like
`#+[` that will match `#[` and `#####[`

* Multiline rule -> Add -->> between two rules to mark the rule as multiline. All the text between the two rules will be skipped,
plus all the text the end rule would skip normally.
  
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

Not allowed rule combinations
* As a rule of thumb, any rule clash will be not allowed unless there is a way to be totally sure of which one
  should be picked.
* For any rules whose actual id/start actual id coincide, they'll be allowed if:
  * Simple rules: they need to use the same action (skip line, or skip just)
  * Multiline rules, they need to have the same start action. Their end rules will then be merged into the multiline
    end syntax tree
* For repeat characters, it wont be allowed if there is any case where two rules have the same character at the same 
  position, one with the `+` rule and the other without.
  * Example: `word` and `wo+rd`
  * Multiple rules with the repeat char rule but with different tails are allowed, or those whose actual id is different
    * Example: `wo+rd` and `wo+rk`, or `wo+rd` and `word\p` (their actual ids are ` wo+rd ` and `word`)

# Improvements
* We are able to support arguments supplying them after the `!e` in the first line. For example, not limiting
  ourselves to 10 lines. It might be useful to add extra meta functionality for specific tracks.

**If you find something missing, please open an issue so we can check its inclusion**

**The representers will end substituting these parsers in the final launch, so please think of this as a "best effort"**