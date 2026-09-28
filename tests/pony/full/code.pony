use "foobar"

/* 
* block
* comment
* syntax
*/

/* block comment on single line */

// Pony also supports nested `/*...*/` comments but that won't work here with our parser

// single-line comment with leading space
//single-line comment with no leading space

primitive TwoFer
  fun apply(name: String = "you"): String =>
    """
    Docstrings are string literals so they can't be safely removed
    """
    "One for " + name + ", one for me." // inline comment
