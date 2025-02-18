const std = @import("std");
const fs = std.fs;
const debug = std.debug;
const process = std.process;

pub fn printUsage() void {
    debug.print(
        \\Usage: ztodo <command> [options]
        \\
        \\Commands:
        \\  init            Initialize a todo app config\n
    , .{});
}
