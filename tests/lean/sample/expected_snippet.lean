inductive TestType
  | here | I | go

def wouldItRemain? (test : TestType) : TestType :=
  match test with
  | .here => .here
  | _     => .go
