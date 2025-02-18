const std = @import("std");
const fs = std.fs;
const debug = std.debug;
const process = std.process;

pub fn createConfigDir(path: []const u8) !void {
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

pub fn createConfigFile(path: []const u8) !void {
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
