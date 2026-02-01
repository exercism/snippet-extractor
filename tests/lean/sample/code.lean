/-
  This
  is
  a
  multiline
  comment
  .
-/
import Std
/-
  This is another multiline comment
  It is between two "import" declarations.
-/
import Lean

open Std
-- this is a single-line comment between two "open" declarations
open Lean

namespace TestModule

/--
  This is a doc multiline comment, after namespace name.
  Would it be stripped away?
  Let us see!
-/
inductive TestType
  | here | I | go
--and without space?

def wouldItRemain? (test : TestType) : TestType :=
  -- a sorry is in order!
  sorry

/-
  I think it is time to end this test file, right?

  Yeah!
-/

end TestModule

-- what about now?
