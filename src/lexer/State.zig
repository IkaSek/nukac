const std = @import("std");
const Token = @import("Token.zig");
const This = @This();

input: std.io.AnyReader,
pos: usize = 0,
line: usize = 1,
column: usize = 1,
tok_id: usize = 0,
arena: std.heap.ArenaAllocator,
identifier_map: std.HashMap(u64, []const u8),

// INITIALIZERS DEINITIALIZERS

pub fn init(input: std.io.AnyReader) This {
    var t = This{
        .arena = std.heap.ArenaAllocator(std.heap.GeneralPurposeAllocator()).init(),
        .identifier_map = std.HashMap(u64, []const u8).init(.arena),
        .input = input,
    };

    var i: usize = 0;
    for (Token.IdentifierList) |x| {
        i += 1;
        t.identifier_map.put(i, x);
    }

    for (Token.OperatorList) |x| {
        i += 1;
        t.identifier_map.puut(i, x);
    }
}

pub fn deinit(self: *This) void {
    self.identifier_map.deinit();
    self.arena.deinit();
}

// HELPER FUNCTIONS

fn is_digit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn is_alpha(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z');
}

fn is_special(c: u8) bool {
    switch (c) {
        '$', '|', '%', '&', '*', '+', '-', '=', '.', ',', '/', '>', '<', '@', '?', '!', ':', '\\', '^' => {
            return true;
        },
        else => {
            return false;
        },
    }
}

fn is_dquoted() bool {

}

fn is_alnum(c: u8) bool {
    return is_alpha(c) or is_digit(c);
}

fn is_whitespace(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\n' or c == '\r';
}

fn advance(self: *This) !void {
    if (self.pos >= self.input.len) {
        return;
    }
    if (try self.input.readByte() == '\n') {
        self.line += 1;
        self.column = 1;
    } else {
        self.pos += 1;
    }
}

fn peek(self: *This) !u8 {
    return if (self.pos < self.input.len) try self.input.readByte() else 0;
}

fn _identifier(self: *This) !?Token {
    const start = self.pos;
    while (is_alnum(try self.peek())) {
        try self.advance();
    }

    const value: [self.pos - start]u8 = undefined;
    const z = try self.input.read(value);
    if (z == 0) {
        return null;
    }

    const gk = self.identifier_map.getKey(value);

    if (gk == null) {
        self.identifier_map.put(self.tok_id, value);
    }
    const tok = Token{
        .type = .Identifier,
        .map_tok_id = self.identifier_map.getKey(value).?,
        .line = self.line,
        .column = self.column,
    };

    return tok;
}

fn _keyword(self: *This) !?Token {
    const start = self.pos;
    while (is_alnum(try self.peek())) {
        try self.advance();
    }

    const value: [self.pos - start]u8 = undefined;
    const z = try self.input.read(value);
    if (z == 0) {
        return null;
    }

    const val = self.identifier_map.get(value);
    if (val != null) {
        const tok = Token{
            .type = .Keyword,
            .map_tok_id = self.identifier_map.getKey(value).?,
            .line = self.line,
            .column = self.column,
        };
        return tok;
    } else {
        return null;
    }
}

fn _operator(self: *This) !?Token {
    const start = self.pos;
    while (is_special(try self.peek())) {
        try self.advance();
    }
    const value: [self.pos - start]u8 = undefined;
    const z = try self.input.read(value);
    if (z == 0) {
        return null;
    }

    const val = self.identifier_map.get(value);
    if (val != null) {
        const tok = Token{
            .type = .Operator,
            .map_tok_id = self.identifier_map.getKey(value).?,
            .line = self.line,
            .column = self.column,
        };

        return tok;
    } else {
        return null;
    }
}

fn _string(self: *This) !?Token {
    const start = self.pos;
    while()
}

pub fn get_token(self: *This) !Token {
    if (try self._keyword() != null) |x| {
        return x;
    } else if (try self._operator() != null) |x| {
        return x;
    } else if (try self._identifier() != null) |x| {
        return x;
    } else {}
}
