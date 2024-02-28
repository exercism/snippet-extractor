#`( Multi-line comment, round parentheses, single line )
#`(( Multi-line comment, double round parentheses, single line ))
sub foo { #`( Multi-
  line comment, single round parentheses, multiple lines )  say #`(( Multi-
  line comment, double round parentheses, multiple lines ))  'baz';
}
