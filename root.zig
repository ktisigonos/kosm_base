//! The base kosmos: the official apps a kosmos chooses, from the theme and its fonts.

const std = @import("std");

/// Every official app; a kosmos returns one, built with `from`.
pub const Base = @import("Base.zig");
/// The fonts the base hands to every app with fonts.
pub const Fonts = @import("Fonts.zig");
/// The chosen apps from the theme, with `fonts`.
pub const from = Base.from;
/// Which of the base's apps a kosmos turns on: `.all`, `.none`, `.{ .only = &.{ .kitty } }` or
/// `.{ .except = &.{ .zen } }`.
pub const Apps = Base.Apps;

test {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(Base);
}
