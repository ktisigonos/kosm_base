//! The fonts every app of the base gets.

/// Family names in fallback order; the first is the main font, which apps taking a single
/// family get. At least one.
families: []const []const u8,
/// The size in points for apps whose text follows it: terminals, notifications, the launcher.
size: f64,
