const std = @import("std");
const lexer = @import("../lexer.zig");
const This = @This();
const ast = @import("ast.zig");
const Error = @import("Error.zig");
usingnamespace @import("_func.zig");

lex: lexer.Lexer,
ast: *ast.AstNode,
top: *ast.AstNode,
arena: std.heap.ArenaAllocator,
allocator: std.mem.Allocator,

pub fn init(lex: lexer.Lexer) !This {
    var p = This{
        .lex = lex,
    };
    p.arena.init(std.heap.GeneralPurposeAllocator({}).init());
    p.allocator = p.arena.allocator();
    p.ast = try p.allocator.create(ast.AstNode);
    p.top = p.ast;
}

pub fn deinit(self: *This) void {
    self.arena.deinit();
}

pub fn parse(self: *This) !void {
    while (true) {
        const tok = self.lex.get_token() catch |err| switch (err) {
            lexer.Error.EndOfStream => {
                // that's all.
                return;
            },
            else => {
                return err;
            },
        };
        if (tok.type != .Keyword) {
            return Error.Error.InvalidPlaceForToken;
        }
        const value = self.lex.identifier_map.get(tok.map_tok_id);
        if (std.mem.eql(u8, value, "func")) {
            try self._func();
        } else if (std.mem.eql(u8, value, "let")) {
            try self._let();
        }
    }
}
