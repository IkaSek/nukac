const std = @import("std");

pub const AstNode = union(enum) {
    const This = @This();
    program: std.ArrayList(AstNode),

    type: struct {
        identifier: []const u8,
        values: ?std.ArrayList(AstNode),
    },
    @"struct": struct {
        values: std.ArrayList(AstNode),
    },
    @"union": struct {
        values: std.ArrayList(AstNode),
    },
    variable: struct {
        identifier: []const u8,
        type: AstNode,
    },
    binary_op: struct {
        lhs: AstNode,
        rhs: AstNode,
    },
    func: struct {
        identifier: []const u8,
        arguments: std.ArrayList(AstNode),
    },
};
