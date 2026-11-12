//! What makes the base look nice: a theme, fonts, the shared values, and a tweak of the
//! base's apps. A look builds no apps, so it works on any base holding the official one.

const Look = @This();

const kosm = @import("kosm");
const Base = @import("Base.zig");
const Fonts = @import("Fonts.zig");
const Values = @import("Values.zig");

/// The colors every app is built from.
theme: kosm.Theme,
/// The fonts every app with fonts gets.
fonts: Fonts,
/// Settings several apps share. Default: none set, so each program's own default applies.
values: Values = .{},
/// Changes to single apps, run after `from` built them and handed out the fonts and values;
/// it gets the look itself to read them. null: no changes.
tweak: ?*const fn (base: *Base, look: Look) void = null,

/// The literal look: pure black, white and hues, monospace at 13, square corners, every other
/// value the program's own.
pub const default: Look = .{
    .theme = .from(.{ .palette = .{
        .black = kosm.hex("000000"),
        .white = kosm.hex("ffffff"),
        .red = kosm.hex("ff0000"),
        .orange = kosm.hex("ff8000"),
        .yellow = kosm.hex("ffff00"),
        .lime = kosm.hex("80ff00"),
        .green = kosm.hex("00ff00"),
        .teal = kosm.hex("00ff80"),
        .cyan = kosm.hex("00ffff"),
        .sky = kosm.hex("0080ff"),
        .blue = kosm.hex("0000ff"),
        .purple = kosm.hex("8000ff"),
        .magenta = kosm.hex("ff00ff"),
        .pink = kosm.hex("ff0080"),
    }, .mode = .dark }),
    .fonts = .{ .families = &.{"monospace"}, .size = 13 },
    .values = .{ .rounding = 0 },
};
