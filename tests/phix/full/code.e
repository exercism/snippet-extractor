/* This is a file
 * With some comments in it
 */

include std/sequence.e
requires("1.0.5")
with javascript_semantics
without nested_globals
namespace none

// And a blank line ⬆️

--/*
     And then, eventually,
        /*
            the code
        */
--*/
global function afunc()
    return 42
end function

//one more comment

?afunc()
