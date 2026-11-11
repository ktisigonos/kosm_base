# kosm_base

The base kosmos: every official app, each from the theme, with the kosmos' fonts. A kosmos
builds on it by choosing a palette and fonts, then overriding single values and dropping the
apps it doesn't want:

```zig
const kosm = @import("kosm");
const base = @import("kosm_base");

pub fn kosmos() base.Base {
    const palette: kosm.Palette = .{ .black = kosm.hex("041c26"), .white = kosm.hex("a3c5cc"), .cyan = kosm.hex("2e9990") };
    var apps = base.from(.from(palette, .dark), .{ .families = &.{ "Maple Mono", "Noto Sans" }, .size = 13 });
    apps.kitty.?.fonts.font_size = 14;
    apps.cs2 = null;
    return apps;
}
```

A kosmos adding apps of its own returns a struct holding the base and them:
`struct { base: base.Base, mine: my_app.App }`.

Every field of `Base` is the app of the package of its name (`kitty` is `kosm_kitty.App`), and
null drops it. Apps that edit a program's own file need that file: `cs16` (the game's
TrackerScheme.res), `darkreader` (its exported settings), `hyprmouse`, `ohmyposh` (a prompt
config with a `palette`), `qtct` (qt5ct's and qt6ct's configs), `tuios`, `vicinae` and `zen`
(a profile). Kosm names the app and file when one is missing; set that app to null. `cs2`
and `blender` write into their programs' folders (the game's, Blender's version folder), which
they create when missing, so drop them on a machine without the program.

## Fonts

`from(theme, fonts)` hands `fonts` to every app with fonts: all families to the apps taking
fallbacks (fontconfig, ghostty, foot, dunst, Hyprland), the first to the rest (kitty, Vicinae,
hyprtoolkit, hyprmouse, Equibop, Counter-Strike 1.6 and 2), and the size to terminals,
notifications and the launcher. `fonts` is known at compile time, written as a literal.

| Field | Meaning |
|---|---|
| `families` | family names in fallback order, at least one; the first is the main font |
| `size` | the size in points |
