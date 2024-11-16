const std = @import("std");

pub const Type = enum {
    Keyword,
    Identifier,
    Number,
    String,
    Symbol,
    Operator,
};

// MyType as struct
pub const IdentifierList = []const u8{
    "if",
    "else",

    "while",

    "for",
    "foreach",

    "func",

    "void",

    "int8",
    "int16",
    "int32",
    "int64",
    "int128",

    "bool",
    "uint8",
    "uint16",
    "uint32",
    "uint64",
    "uint128",

    "float16",
    "float32",
    "float64",
    "float80",
    "float128",

    "struct",
    "union",
    "enum",
    "import",

    "let",

    "pub",
    "mut",

    "volatile",
    "restrict",
    "atomic",
    "consteval",

    "as",

    "and",
    "or",
    "not",
};

pub const OperatorList = []const u8{
    ".",
    ":",
    ",",
    "|",
    "&",
    "^",
    "!",
    "?",
    "=",
    "!=",
    "==",
    "<",
    ">",
    ">=",
    "<=",
    "$",
    "*",
    "%",
    "+",
    "-",
    "/",
    ">>",
    "<<",
    "->",
};

type: Type,
map_tok_id: usize,
line: usize,
column: usize,
