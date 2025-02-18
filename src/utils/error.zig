const std = @import("std");
const fs = std.fs;
const debug = std.debug;
const process = std.process;

pub const CommandError = error{ InvalidCommand, MissingArguments };
