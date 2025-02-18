const std = @import("std");
const errors = @import("../utils/error.zig");
const commandHelp = @import("help.zig");
const file = @import("../utils/file.zig");
const debug = std.debug;
const process = std.process;

pub fn handleInit(args: *process.ArgIterator) !void {
    const path = "data";
    const file_path = "data/config.json";
    var arg_string: ?[]const u8 = null;

    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            commandHelp.printUsage();
        } else {
            arg_string = args.next();
            debug.print("Invalid command found {s}\n", .{arg_string.?});
            return errors.CommandError.InvalidCommand;
        }
    }

    try file.createConfigDir(path);
    try file.createConfigFile(file_path);
}
