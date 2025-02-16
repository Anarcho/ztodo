const std = @import("std");
const fs = std.fs;
const debug = std.debug;
const process = std.process;

const CommandError = error{ InvalidCommand, MissingArguments };

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var args = try process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip();

    const command = args.next() orelse {
        return CommandError.MissingArguments;
    };

    // Argument routing
    if (std.mem.eql(u8, command, "init")) {
        try handleInit(&args);
    } else {
        debug.print("Unknown command: {s}\n", .{command});
        printUsage();
        return CommandError.InvalidCommand;
    }
}

fn handleInit(args: *process.ArgIterator) !void {
    const path = "data";
    const file_path = "data/config.json";
    var arg_string: ?[]const u8 = null;

    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            printUsage();
        } else {
            arg_string = args.next();
            debug.print("Invalid command found {s}\n", .{arg_string.?});
            return CommandError.InvalidCommand;
        }
    }

    try createConfigDir(path);
    try createConfigFile(file_path);
}

fn createConfigDir(path: []const u8) !void {
    fs.cwd().access(path, .{}) catch |err| switch (err) {
        error.BadPathName => {
            debug.print("Bad path name for provided path: {s}\n", .{path});
            return err;
        },
        error.FileNotFound => {
            try fs.cwd().makeDir(path);
            debug.print("Directory created at: {s}\n", .{path});
            return;
        },
        error.PermissionDenied => {
            debug.print("Permission denied when creating directory at path: {s}\n", .{path});
            return err;
        },
        else => {
            debug.print("Unexpected error occurred creating directory at path: {s}\n", .{path});
            return err;
        },
    };
    debug.print("Path already exists at path: {s}\n", .{path});
}

fn createConfigFile(path: []const u8) !void {
    const file = fs.cwd().createFile(path, .{ .exclusive = true }) catch |err| switch (err) {
        error.FileNotFound => {
            debug.print("Directory does not exist: {s}\n", .{path});
            return err;
        },
        error.AccessDenied => {
            debug.print("Permisson denied when attempting to create file at path: {s}\n", .{path});
            return err;
        },
        error.PathAlreadyExists => {
            debug.print("Config already exists at {s}\n", .{path});
            return;
        },
        else => {
            debug.print("An unexpected error has occurred when creating config file at path: {s}\n", .{path});
            return err;
        },
    };
    defer file.close();
}

fn printUsage() void {
    debug.print(
        \\Usage: ztodo <command> [options]
        \\
        \\Commands:
        \\  init            Initialize a todo app config
    , .{});
}
