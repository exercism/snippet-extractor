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

* There can only be one rule with the same first id. If there are more than one, an exception will occur when creating
  the trie. Possible improvement if its really necessary.

**If you find something missing, please open an issue so we can check its inclusion**

**The representers will end substituting these parsers in the final launch, so please think of this as a "best effort"**