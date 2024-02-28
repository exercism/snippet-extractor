#`[ Multi-line comment, square parentheses, single line ]
#`[[ Multi-line comment, double square parentheses, single line ]]
sub foo { #`[ Multi-
  line comment, square parentheses, multiple lines ]  say #`[[ Multi-
  line comment, double square parentheses, multiple lines ]]  'baz';
}
