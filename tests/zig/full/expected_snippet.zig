pub fn twoFer(name: ?[]const u8) []const u8 {
    const stringWithSlashes = "foo////bar"
    return if (name) |value|
        std.fmt.allocPrint(std.heap.page_allocator, "One for {s}, one for me.", .{value}) catch unreachable
    else
        "One for you, one for me.";
}
