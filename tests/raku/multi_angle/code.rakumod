#`< Multi-line comment, angle parentheses, single line >
#`<< Multi-line comment, double angle parentheses, single line >>
sub foo { #`< Multi-
  line comment, angle parentheses, multiple lines >  say #`<< Multi-
  line comment, double angle parentheses, multiple lines >>  'baz';
}
