const std = @import("std");
const expect = std.testing.expect;

test "testing simple sum" {
    const a: u8 = 2;
    const b: u8 = 2;

    try expect((a + b) == 4);
}
