//! Settings several official apps share, set once: `from` hands each to every app having that
//! setting. Every value left null is not written, so each program's own default applies.

const kosm = @import("kosm");

/// Width of window borders in pixels: Hyprland's `general.border_size`, wlr-which-key's
/// `border_width`, Vicinae's `border_width`, dunst's `frame_width`, the outline around
/// Blender's selected objects (1 to 5 pixels). null: not written.
border_size: ?u32 = null,
/// Colors of window borders.
borders: Borders = .{},
/// Corner radius in pixels: Hyprland's windows, hyprtoolkit's large elements (its small ones
/// get half), Zen's content, wlr-which-key's menu, Vicinae's window, dunst's notifications,
/// Blender's widgets and panels, Commet's panels, Equibop's messages and popouts. null: not
/// written.
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
/// How translucent windows blur what is behind them. Translucency itself is the theme's
/// `background_alpha`.
blur: Blur = .{},
/// The pointer.
cursor: Cursor = .{},
/// The icon theme's name: GTK, KDE, qt5ct and qt6ct, hyprtoolkit and Vicinae. null: the icons app's theme (`kosm`), or
/// not written without that app.
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

/// Colors of window borders.
pub const Borders = struct {
    /// The focused window's border, and the frame of menus, the launcher and notifications:
    /// Hyprland's `general.col.active_border`, kitty's `active_border_color`, wlr-which-key's
    /// `border`, Vicinae's `core.border`, dunst's `frame_color` (critical ones keep the error
    /// role), Zen's glance outline. A role follows the theme the look is worn with. null:
    /// each app's own, the accent role.
    active: ?BorderColor = null,
    /// Unfocused windows' borders: Hyprland's `general.col.inactive_border`, kitty's
    /// `inactive_border_color`. null: derived from `active` through the theme's
    /// `state.inactive`, as each app does from the accent.
    inactive: ?BorderColor = null,
};

/// A border's color: a role of the theme the look is worn with, so it follows that theme (one
/// taken from an image too), or a fixed color.
pub const BorderColor = union(enum) {
    /// This role's color in the worn theme: `.{ .role = .accent }`.
    role: kosm.Theme.Roles.Name,
    /// This color, whatever the theme: `.{ .color = kosm.hex("2e8799") }`.
    color: kosm.Color,

    /// The color in `theme`.
    pub fn resolve(border_color: BorderColor, theme: kosm.Theme) kosm.Color {
        return switch (border_color) {
            .role => |name| theme.roles.get(name),
            .color => |color| color,
        };
    }
};

/// How translucent windows blur what is behind them.
pub const Blur = struct {
    /// Whether windows blur at all, apart from how far: Hyprland's `decoration.blur.enabled`
    /// (on, its xray and blur effects keep working even at size 0), Ghostty's
    /// `background-blur` (`false` when off), kitty's `background_blur` (0 when off), foot's
    /// `blur` in both color themes and Vicinae's `material` (`blur` or `none`). The terminals'
    /// own blur is drawn only by compositors offering it, such as KDE's; Hyprland blurs them by
    /// itself. null: not written.
    enabled: ?bool = null,
    /// How far the blur reaches, in pixels: Hyprland's `decoration.blur.size`, Ghostty's
    /// `background-blur` intensity and kitty's `background_blur` (on Linux only on or off, so
    /// at least 1 while enabled). Turns nothing on or off. null: not written.
    size: ?u32 = null,
    /// How many times the blur is applied, each spreading it further: Hyprland's
    /// `decoration.blur.passes` (1 to 4 look good). null: not written.
    passes: ?u32 = null,
};

/// Window shadows.
pub const Shadow = struct {
    /// How far the shadow reaches, in pixels: Hyprland's `decoration.shadow.range`, Vicinae's
    /// `shadow_size`, Blender's menu and panel shadows (times its `shadow_scale`). null: not
    /// written.
    range: ?u32 = null,
    /// How fast the shadow fades, 1 to 4: Hyprland's `decoration.shadow.render_power`.
    /// null: not written.
    render_power: ?u32 = null,
};

/// The pointer.
pub const Cursor = struct {
    /// The cursor theme's name: GTK's, and Hyprland's `XCURSOR_THEME` and `HYPRCURSOR_THEME`.
    /// null: the cursor app's theme (`kosm_cursor`), or not written without that app.
    name: ?[]const u8 = null,
    /// The cursor's size in pixels: GTK's, and Hyprland's `XCURSOR_SIZE` and
    /// `HYPRCURSOR_SIZE`. null: not written.
    size: ?u32 = null,
};
