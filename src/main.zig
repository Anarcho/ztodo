const std = @import("std");
const fs = std.fs;
const debug = std.debug;
const process = std.process;

const errors = @import("./utils/error.zig");
const commandInit = @import("./commands/init.zig");
const commandHelp = @import("./commands/help.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var args = try process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip();

    const command = args.next() orelse {
        return errors.CommandError.MissingArguments;
    };

    // Argument routing
    if (std.mem.eql(u8, command, "init")) {
        try commandInit.handleInit(&args);
    } else {
        debug.print("Unknown command: {s}\n", .{command});
        commandHelp.printUsage();
        return errors.CommandError.InvalidCommand;
    }
}
