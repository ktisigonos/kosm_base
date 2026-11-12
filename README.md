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

`base.Look.default` is the literal look: pure black, white and hues (`#ff0000`, ...), monospace
at 13, square corners, every other value the program's own. A look is known at compile time,
written as a `const`.

A kosmos adding apps of its own returns a struct holding the base and them:
`struct { base: base.Base, mine: my_app.App }`, building its own from `look.theme`, so they
follow the look's roles like the official ones.

Every field of `Base` is the app of the package of its name (`kitty` is `kosm_kitty.App`).

## Choosing apps

The last argument of `from` says which apps are on; the others are null and never applied.

| Value | Apps on |
|---|---|
| `.all` | every app |
| `.none` | none, for a kosmos made only of apps of its own |
| `.{ .only = &.{ .kitty, .ghostty } }` | the listed ones |
| `.{ .except = &.{ .zen } }` | every app but the listed ones |

The names are `Base`'s fields (the enum `base.Base.App`); naming one twice is fine.

Apps that edit a program's own file need that file: `counter_strike` (the
game's TrackerScheme.res), `darkreader` (its exported settings), `hyprmouse`, `qtct` (qt5ct's and qt6ct's configs), `tuios`, `vicinae` and
`zen` (a profile). Kosm names the app and file when one is missing; leave that app out.
`counter_strike_2` and `blender` write into their programs' folders (the game's, Blender's
version folder), which they create when missing, so leave them out on a machine without the program.
`fastfetch` owns `~/.config/fastfetch/config.jsonc` whole and replaces one written by hand, so lay
fastfetch out through the app's fields (`kosm_fastfetch`'s README) or leave it out. `ohmyposh`
owns `~/.config/oh-my-posh/kosm.json` the same way; point `oh-my-posh init` at it, and run
`oh-my-posh enable reload` once so open shells follow an apply (`kosm_ohmyposh`'s README).

## Fonts

`from(look, apps)` hands the look's `fonts` to every app with fonts: all families to the apps taking
fallbacks (fontconfig, ghostty, foot, dunst, Hyprland), the first to the rest (kitty, Vicinae,
hyprtoolkit, hyprmouse, Equibop, Counter-Strike 1.6 and 2), and the size to terminals,
notifications and the launcher. GTK gets the first family at the size as its interface,
monospace and document font (`Maple Mono 13`).

| Field | Meaning |
|---|---|
| `families` | family names in fallback order, at least one; the first is the main font |
| `size` | the size in points |

## Look

| Field | Meaning |
|---|---|
| `theme` | the colors every app is built from |
| `fonts` | the fonts above |
| `values` | the shared values below; default: none set |
| `tweak` | `fn (base: *Base, look: Look) void`, run last to change single apps; null: none |

## Shared values

`from` sets each value of `look.values` in every app having that setting. A value left null is
not written, so each program's own default applies.

| Field | Apps |
|---|---|
| `border_size` | Hyprland's `general.border_size` |
| `rounding` | Hyprland's `decoration.rounding`, hyprtoolkit's `rounding_large` (`rounding_small` half), Zen's `zen.theme.border-radius` |
| `rounding_power` | Hyprland's `decoration.rounding_power` |
| `gaps.inner`, `gaps.outer` | Hyprland's `general.gaps_in`, `general.gaps_out` |
| `padding` | Ghostty's `window-padding-x` and `-y`, kitty's `window_padding_width`, foot's `pad` |
| `shadow.range`, `shadow.render_power` | Hyprland's `decoration.shadow` |
| `cursor.name`, `cursor.size` | GTK's cursor theme and size, Hyprland's `XCURSOR_*` and `HYPRCURSOR_*` |
| `icon_theme` | GTK's and hyprtoolkit's icon theme |
| `keyboard` | Hyprland's `input.kb_*` (a `kosm.Keyboard`) |
| `editor` | kitty's `editor` |
