//! The base kosmos: the official apps a kosmos chooses, from a look.

const std = @import("std");

/// Every official app; a kosmos returns one, built with `from`.
pub const Base = @import("Base.zig");
/// What makes the base look nice: a theme, fonts, shared values and a tweak of the apps.
pub const Look = @import("Look.zig");
/// The fonts the base hands to every app with fonts.
pub const Fonts = @import("Fonts.zig");
/// Settings several apps share, set once for every app having them.
pub const Values = @import("Values.zig");
/// The chosen apps from a look.
pub const from = Base.from;
/// Which of the base's apps a kosmos turns on: `.all`, `.none`, `.{ .only = &.{ .kitty } }` or
/// `.{ .except = &.{ .zen } }`.
pub const Apps = Base.Apps;

test {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(Base);
}
