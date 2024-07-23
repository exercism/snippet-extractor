//! we will need this, trust me!
use lib::some_function;

// Hmmmmmmmm

/// This comment is explaing
/// a lot!!!
mod two_fer { // we don't really
    // have actual multiline
    // comments!!
    fn two_fer(name: ByteArray) -> ByteArray {
        // There might be a comment here
        return "One for " + name + ", one for me."; // A comment after a valid line 
    }
} // module two_fer
