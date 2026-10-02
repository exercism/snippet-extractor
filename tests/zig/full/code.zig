//! This is a top-level doc comment describing the entire file
//! This can be multiple lines.

const std = @import("std"); // this is code but this is in every exercise so it's boring

/// This line might describe what the function does
/// This line might document its parameters
/// This line might document its return value(s)
pub fn twoFer(name: ?[]const u8) []const u8 {
    // this is is a single-line comment
    const stringWithSlashes = "foo////bar"
    return if (name) |value| // this line should stay
        std.fmt.allocPrint(std.heap.page_allocator, "One for {s}, one for me.", .{value}) catch unreachable
    else
        "One for you, one for me.";
}
