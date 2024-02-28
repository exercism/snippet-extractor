//// This is a file
//// With some comments in it

// And a blank line ⬆️
// It has some imports like this:
import gleam/erlang
import gleam/erlang/process.{Subject}

/// And then eventually the code
pub fn two_fer(name: String) -> String {
  todo// with comments
}

// Here is a comment
/// And a documentation comment
pub type TwoFer {
  TwoFer(name: String)
}

const a = 1
const b = 1
const c = 1 // More, but this is over 10 lines so it wont appear
