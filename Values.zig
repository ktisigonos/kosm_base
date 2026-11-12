//! Settings several official apps share, set once: `from` hands each to every app having that
//! setting. Every value left null is not written, so each program's own default applies.

const kosm = @import("kosm");

/// Width of window borders in pixels: Hyprland's `general.border_size`. null: not written.
border_size: ?u32 = null,
/// Corner radius in pixels: Hyprland's windows, hyprtoolkit's large elements (its small ones
/// get half), Zen's content. null: not written.
rounding: ?u32 = null,
/// How round corners are, 2 being a circle: Hyprland's `decoration.rounding_power`.
/// null: not written.
rounding_power: ?f64 = null,
/// Space between windows and around them.
gaps: Gaps = .{},
/// Space in pixels between a terminal's text and its window edge: Ghostty, kitty and foot.
/// null: not written.
padding: ?u32 = null,
/// Window shadows.
shadow: Shadow = .{},
/// The pointer.
cursor: Cursor = .{},
/// The icon theme's name: GTK and hyprtoolkit. null: not written.
icon_theme: ?[]const u8 = null,
/// Keyboard layouts, variants and options: Hyprland's `input.kb_*`. null: not written.
keyboard: ?kosm.Keyboard = null,
/// The terminal editor programs open files in: kitty's `editor`. null: not written.
editor: ?[]const u8 = null,

/// Space between windows and around them.
pub const Gaps = struct {
    /// Between windows, in pixels: Hyprland's `general.gaps_in`. null: not written.
    inner: ?u32 = null,
    /// Between windows and the screen's edges, in pixels: Hyprland's `general.gaps_out`.
    /// null: not written.
    outer: ?u32 = null,
};

/// Window shadows.
pub const Shadow = struct {
    /// How far the shadow reaches, in pixels: Hyprland's `decoration.shadow.range`.
    /// null: not written.
    range: ?u32 = null,
    /// How fast the shadow fades, 1 to 4: Hyprland's `decoration.shadow.render_power`.
    /// null: not written.
    render_power: ?u32 = null,
};

/// The pointer.
pub const Cursor = struct {
    /// The cursor theme's name: GTK's, and Hyprland's `XCURSOR_THEME` and `HYPRCURSOR_THEME`.
    /// null: not written.
    name: ?[]const u8 = null,
    /// The cursor's size in pixels: GTK's, and Hyprland's `XCURSOR_SIZE` and
    /// `HYPRCURSOR_SIZE`. null: not written.
    size: ?u32 = null,
};
