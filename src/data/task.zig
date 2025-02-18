const std = @import("std");
const fs = std.fs;
const debug = std.debug;
const process = std.process;

pub const Status = enum {
    Pending,
    Started,
    Completed,
};

pub const task = struct {
    id: u64,
    title: []const u8,
    description: []const u8,
    status: Status,
};
