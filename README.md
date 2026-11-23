# kosm_base

The base kosmos: every official app, built from a look. A look is what makes the base look
nice: a theme, fonts, the shared values and a tweak of single apps. A kosmos picks a look and the
apps it wants, then overrides single values:

```zig
const kosm = @import("kosm");
const base = @import("kosm_base");

const look: base.Look = .{
    .theme = .from(.{ .palette = .{ .black = kosm.hex("041c26"), .white = kosm.hex("a3c5cc"), .cyan = kosm.hex("2e9990") }, .mode = .dark }),
    .fonts = .{ .families = &.{ "Maple Mono", "Noto Sans" }, .size = 13 },
    .values = .{ .rounding = 10, .padding = 10 },
};

pub fn kosmos() base.Base {
    var apps = base.from(look, .{ .except = &.{.counter_strike_2} });
    apps.kitty.?.fonts.font_size = 14;
    return apps;
}
```

The base is also a kosmos of its own: `kosm apply kosm_base` wears every app in the literal look,
and fails naming the file where an app edits one the machine lacks (Counter-Strike not installed).

`base.Look.default` is the literal look: pure black, white and hues (`#ff0000`, ...), monospace
at 13, square corners, every other value the program's own. A look may be a `const` or built at
run time, so a look written in a script (Lua) gives a base too:
`kosm_base.from({ theme = theme, fonts = { families = { "Maple Mono" }, size = 13 } }, "all")`.

A theme known only at run time, like one taken from a wallpaper (`kosm.Image` in the kosmos'
`Params`), wears a look through `base.fromTheme(look, theme, apps)`: the look's fonts, values
and tweak with that theme in place of its own.

Hyprland's logo and splash text are off, so behind the wallpaper is the theme's background
alone and switching wallpapers only flashes that color.

A kosmos adding apps of its own returns a struct holding the base and them:
`struct { base: base.Base, mine: my_app.App }`, building its own from `look.theme`, so they
follow the look's roles like the official ones.

Every field of `Base` but `theme` is the app of the package of its name (`kitty` is
`kosm_kitty.App`). `theme` holds the theme the apps were built from, which `kosm colors` shows;
changing it changes no app.

## Choosing apps

The last argument of `from` says which apps are on; the others are null and never applied.

| Value | Apps on |
|---|---|
| `.all` | every app |
| `.none` | none, for a kosmos made only of apps of its own |
| `.{ .only = &.{ .kitty, .ghostty } }` | the listed ones |
| `.{ .except = &.{ .zen } }` | every app but the listed ones |

The names are `Base`'s fields (the enum `base.Base.App`); naming one twice is fine.

Apps that edit a program's own file need that file: `commet` (its Flatpak's
`shared_preferences.json`), `counter_strike` (the game's TrackerScheme.res), `hyprmouse`, `qtct` (qt5ct's and qt6ct's configs), `tuios`, `vicinae`, `wlr_which_key` (its `config.yaml`) and
`zen` (a profile, with the kosm mod's entry in its `zen-themes.json`). Kosm names the app and file when one is missing; leave that app out.
`counter_strike_2` and `blender` write into their programs' folders (the game's, Blender's
version folder), which they create when missing, so leave them out on a machine without the program.
`fastfetch` owns `~/.config/fastfetch/config.jsonc` whole and replaces one written by hand, so lay
fastfetch out through the app's fields (`kosm_fastfetch`'s README) or leave it out. `ohmyposh`
owns `~/.config/oh-my-posh/kosm.json` the same way; point `oh-my-posh init` at it, and run
`oh-my-posh enable reload` once so open shells follow an apply (`kosm_ohmyposh`'s README).
`icons` writes BeautyLine in the theme's colors to `~/.local/share/icons/kosm` (thousands of files,
shown as one line in a diff), which GTK, KDE, qt5ct, qt6ct, hyprtoolkit and Vicinae then pick; `kosm_icons`' README has a
system theme instead.
`cursor` writes Bibata in the theme's colors to `~/.local/share/icons/kosm_cursor`, for XCursor
and hyprcursor, which GTK and Hyprland then pick; it needs the `resvg` library to build
(`kosm_cursor`'s README).
`hyprpaper` owns `~/.config/hypr/hyprpaper.conf` whole once a kosmos sets a wallpaper
(`apps.hyprpaper.?.wallpapers`), or with `owned = false` only sets the wallpapers in the user's
own file; with none set it writes nothing (`kosm_hyprpaper`'s README).

## Fonts

`from(look, apps)` hands the look's `fonts` to every app with fonts: all families to the apps taking
fallbacks (fontconfig, ghostty, foot, dunst, Hyprland), the first to the rest (kitty, Vicinae,
hyprtoolkit, hyprmouse, Equibop, Counter-Strike 1.6 and 2), and the size to terminals,
notifications and the launcher. GTK gets the first family at the size as its interface,
monospace and document font (`Maple Mono 13`), and qt5ct and qt6ct as their general and fixed
font.

Text with a role of its own gets the size plus that role's delta, so every size follows `size`:
wlr-which-key gets every family at the `large` size as one Pango font (`Maple Mono, Noto Sans 16`),
and hyprtoolkit its headings, body and small text (h1 `heading`, h2 `subheading`, h3 and body
the size, small text `small`, rounded to whole points).

A look with no family hands out only the sizes, so each program keeps its own font.

| Field | Meaning |
|---|---|
| `families` | family names in fallback order, at least one; the first is the main font |
| `size` | the size in points |
| `deltas.large` | points added for short text read at a glance (wlr-which-key); default +3 |
| `deltas.small` | points added for secondary text (hyprtoolkit's small text); default -4 |
| `deltas.heading` | points added for the largest headings (hyprtoolkit's h1); default +12 |
| `deltas.subheading` | points added for second-level headings (hyprtoolkit's h2); default +3 |

## Look

| Field | Meaning |
|---|---|
| `theme` | the colors every app is built from |
| `fonts` | the fonts above |
| `values` | the shared values below; default: none set |
| `tweak` | `fn (base: *Base, look: Look) void`, run last to change single apps; null: none |

## A look from an image

`look.fromImage(image, options)` wears `look` in colors taken from `image` (a `kosm.Image` in the
kosmos' `Params`) and derives its translucency and shared values from the picture, each within a
range of `base.ImageOptions` (a range of `n..n` pins the value). Fonts, tweak and every value it
does not derive stay the look's; assign any value afterwards to override it.

| Option | Derived value, default range |
|---|---|
| `colors` | how colors are taken, and the picture measured in its `traits` (`kosm.Image.Options`) |
| `alpha` | the theme's `background_alpha`: the lowest at which some blur in range keeps text readable; 0.6..1 |
| `blur_size`, `blur_passes` | `blur`: the least that keeps text readable at that alpha; 0..10 and 2..4 |
| `rounding`, `rounding_power` | rounder and nearer a circle for softer pictures; 4..16 and 2..4 |
| `gaps_inner`, `gaps_outer` | smaller for busier pictures; 2..6 and 4..12 |
| `border_size` | thinner for softer pictures; 1..3 |
| `padding` | roomier for softer pictures; 6..14 |
| `shadow_range`, `shadow_render_power` | wider and slower to fade for softer pictures; 4..20 and 2..4 |

## Shared values

`from` sets each value of `look.values` in every app having that setting. A value left null is
not written, so each program's own default applies.

| Field | Apps |
|---|---|
| `border_size` | Hyprland's `general.border_size`, wlr-which-key's `border_width`, Vicinae's `border_width`, dunst's `frame_width`, Blender's `border_size` (the outline around selected objects, 1 to 5 px) |
| `borders.active` | Hyprland's `general.col.active_border`, kitty's `active_border_color`, wlr-which-key's `border`, Vicinae's `core.border`, dunst's `frame_color` (critical keeps the error role), Zen's glance outline; `.{ .role = .accent }` follows the worn theme, `.{ .color = ... }` is fixed; null: each app's accent |
| `borders.inactive` | Hyprland's `general.col.inactive_border`, kitty's `inactive_border_color`; a role or a color, as `borders.active`; null: derived from `borders.active` through the theme's `state.inactive` |
| `rounding` | Hyprland's `decoration.rounding`, hyprtoolkit's `rounding_large` (`rounding_small` half), Zen's `zen.theme.border-radius`, Firefox's forced page corners (off until `firefox.enabled.corners` or the toolbar button turns them on), wlr-which-key's `corner_r`, Vicinae's `rounding`, dunst's `corner_radius`, Blender's `rounding` (its widgets' and panels' roundness), Commet's `caulk_border_radius`, Equibop's `rounding` |
| `rounding_power` | Hyprland's `decoration.rounding_power` |
| `gaps.inner`, `gaps.outer` | Hyprland's `general.gaps_in`, `general.gaps_out` |
| `padding` | Ghostty's `window-padding-x` and `-y`, kitty's `window_padding_width`, foot's `pad` |
| `shadow.range`, `shadow.render_power` | Hyprland's `decoration.shadow`; the range also Vicinae's `shadow_size` and Blender's `shadow_range` (menu shadows, times its `shadow_scale`) |
| `blur.enabled` | whether windows blur at all, apart from how far (on, Hyprland's xray and blur effects keep working at size 0): Hyprland's `decoration.blur.enabled`, Ghostty's `background-blur` (`false` when off), kitty's `background_blur` (0 when off), foot's `blur` in both color themes and Vicinae's `material` (`blur` or `none`); the terminals' own blur is drawn by compositors offering it, such as KDE, while Hyprland blurs on its own |
| `blur.size` | how far the blur reaches, turning nothing on or off: Hyprland's `decoration.blur.size`, Ghostty's `background-blur` intensity and kitty's `background_blur` (at least 1 while enabled); how translucent windows are is the theme's `background_alpha` |
| `blur.passes` | Hyprland's `decoration.blur.passes` |
| `cursor.name`, `cursor.size` | GTK's cursor theme and size, Hyprland's `XCURSOR_*` and `HYPRCURSOR_*`; null name picks the `cursor` app's theme, and the size is also the one `cursor` tells Hyprland to reload at |
| `icon_theme` | GTK's, KDE's, qt5ct's and qt6ct's, hyprtoolkit's and Vicinae's icon theme; null picks the `icons` app's theme |
| `keyboard` | Hyprland's `input.kb_*` (a `kosm.Keyboard`) |
| `editor` | kitty's `editor` |
