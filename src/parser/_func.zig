const std = @import("std");
const Parser = @import("../parser.zig").Parser;
const Error = @import("Error.zig");

fn _func_args(self: *Parser, arg_counter: usize) !void {
    const id = try self.lex.get_token();
    if (id.map_tok_id != self.lex.identifier_map.getKey(")")) {
        self._func_args(arg_counter + 1);
    }

    if (try self.lex.get_token() != self.lex.identifier_map.getKey(",")) {
        return Error.Error.InvalidPlaceForToken;
    }

    const old_top = self.top;
    self.top = self.top.func.arguments.items[arg_counter];
    self.parse();
    self.top = old_top;
}

pub fn _func(self: *Parser) !void {
    self.top.func.arguments.init(self.allocator);
    const fn_identifier_tok = try self.lex.get_token();
    if (fn_identifier_tok.type != .Identifier) {
        return Error.Error.InvalidPlaceForToken;
    }

    const fn_identifier_val = self.lex.identifier_map.get(fn_identifier_tok.map_tok_id);
    self.top.func.identifier = try self.allocator.dupe(u8, fn_identifier_val);

    self._func_args(0);
}
