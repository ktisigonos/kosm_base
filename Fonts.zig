//! The fonts every app of the base gets.

const Fonts = @This();

/// Family names in fallback order; the first is the main font, which apps taking a single
/// family get. Empty: no app gets a family, so each program keeps its own font.
families: []const []const u8,
/// The size in points for apps whose text follows it: terminals, notifications, the launcher, GTK.
size: f64,
/// Points added to `size` for text with a role of its own, so every size follows `size`.
deltas: Deltas = .{},

/// Points added to `size` per role; negative shrinks.
pub const Deltas = struct {
    /// Short text read at a glance: wlr-which-key's menu. Default: +3.
    large: f64 = 3,
    /// Secondary text: hyprtoolkit's small text. Default: -4.
    small: f64 = -4,
    /// The largest headings: hyprtoolkit's h1. Default: +12.
    heading: f64 = 12,
    /// Second-level headings: hyprtoolkit's h2. Default: +3.
    subheading: f64 = 3,
};

/// The size in points of text whose role adds `delta` to `size`.
pub fn plus(fonts: Fonts, delta: f64) f64 {
    return fonts.size + delta;
}

/// `plus(delta)` rounded to whole points, for apps taking only those.
pub fn wholePlus(fonts: Fonts, delta: f64) i64 {
    return @intFromFloat(@round(fonts.plus(delta)));
}
