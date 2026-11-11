//! The base kosmos: every official app from the theme and the kosmos' fonts.

const std = @import("std");

/// Every official app; a kosmos returns one, built with `from`.
pub const Base = @import("Base.zig");
/// The fonts the base hands to every app with fonts.
pub const Fonts = @import("Fonts.zig");
/// Every app from the theme, with `fonts`.
pub const from = Base.from;

test {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(Base);
}
