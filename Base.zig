//! Every official app the kosmos chose, each from the theme with the kosmos' fonts. A kosmos
//! returns this after overriding single values.

const Base = @This();

const std = @import("std");
const kosm = @import("kosm");
const kosm_adwsteamgtk = @import("kosm_adwsteamgtk");
const kosm_blender = @import("kosm_blender");
const kosm_counter_strike = @import("kosm_counter_strike");
const kosm_counter_strike_2 = @import("kosm_counter_strike_2");
const kosm_darkreader = @import("kosm_darkreader");
const kosm_dunst = @import("kosm_dunst");
const kosm_equibop = @import("kosm_equibop");
const kosm_fontconfig = @import("kosm_fontconfig");
const kosm_foot = @import("kosm_foot");
const kosm_ghostty = @import("kosm_ghostty");
const kosm_gtk = @import("kosm_gtk");
const kosm_hyprland = @import("kosm_hyprland");
const kosm_hyprmouse = @import("kosm_hyprmouse");
const kosm_hyprtoolkit = @import("kosm_hyprtoolkit");
const kosm_kde = @import("kosm_kde");
const kosm_kitty = @import("kosm_kitty");
const kosm_nvim = @import("kosm_nvim");
const kosm_ohmyposh = @import("kosm_ohmyposh");
const kosm_qtct = @import("kosm_qtct");
const kosm_tuios = @import("kosm_tuios");
const kosm_vicinae = @import("kosm_vicinae");
const kosm_zen = @import("kosm_zen");

const Fonts = @import("Fonts.zig");

/// Steam's custom CSS for its Adwaita skin. null: not riced.
adwsteamgtk: ?kosm_adwsteamgtk.App,
/// Blender's interface theme preset. null: not riced.
blender: ?kosm_blender.App,
/// Counter-Strike 1.6's menu colors and font; needs the game's TrackerScheme.res. null: not riced.
counter_strike: ?kosm_counter_strike.App,
/// Counter-Strike 2's UI font. null: not riced.
counter_strike_2: ?kosm_counter_strike_2.App,
/// Dark Reader's colors; needs its exported settings file. null: not riced.
darkreader: ?kosm_darkreader.App,
/// dunst's notifications. null: not riced.
dunst: ?kosm_dunst.App,
/// Equibop's QuickCSS colors and font. null: not riced.
equibop: ?kosm_equibop.App,
/// fontconfig's default families. null: not riced.
fontconfig: ?kosm_fontconfig.App,
/// foot's colors and fonts. null: not riced.
foot: ?kosm_foot.App,
/// Ghostty's colors and fonts. null: not riced.
ghostty: ?kosm_ghostty.App,
/// GTK 4 (libadwaita) and GTK 3 (adw-gtk3) colors. null: not riced.
gtk: ?kosm_gtk.App,
/// Hyprland's colors and font. null: not riced.
hyprland: ?kosm_hyprland.App,
/// hyprmouse's overlay; needs its hyprmouse.conf. null: not riced.
hyprmouse: ?kosm_hyprmouse.App,
/// hyprtoolkit apps' colors and fonts. null: not riced.
hyprtoolkit: ?kosm_hyprtoolkit.App,
/// KDE's color scheme and kdeglobals. null: not riced.
kde: ?kosm_kde.App,
/// kitty's colors and font. null: not riced.
kitty: ?kosm_kitty.App,
/// Neovim's base16 colors. null: not riced.
nvim: ?kosm_nvim.App,
/// oh-my-posh's palette; needs a prompt config with a `palette`. null: not riced.
ohmyposh: ?kosm_ohmyposh.App,
/// qt5ct's and qt6ct's color schemes; needs their configs. null: not riced.
qtct: ?kosm_qtct.App,
/// tuios' theme; needs its config.toml. null: not riced.
tuios: ?kosm_tuios.App,
/// Vicinae's theme and font; needs its settings.json. null: not riced.
vicinae: ?kosm_vicinae.App,
/// Zen Browser's colors, logo and prefs. null: not riced.
zen: ?kosm_zen.App,

/// One of the base's apps, named as its field.
pub const App = enum {
    adwsteamgtk,
    blender,
    counter_strike,
    counter_strike_2,
    darkreader,
    dunst,
    equibop,
    fontconfig,
    foot,
    ghostty,
    gtk,
    hyprland,
    hyprmouse,
    hyprtoolkit,
    kde,
    kitty,
    nvim,
    ohmyposh,
    qtct,
    tuios,
    vicinae,
    zen,
};

/// Which of the base's apps a kosmos turns on; the others are null and never applied.
/// A list may name an app twice.
pub const Apps = union(enum) {
    /// Every app.
    all,
    /// No app; for a kosmos made only of apps of its own.
    none,
    /// Only the listed apps.
    only: []const App,
    /// Every app but the listed ones.
    except: []const App,

    /// Whether `app` is on.
    pub fn has(apps: Apps, app: App) bool {
        return switch (apps) {
            .all => true,
            .none => false,
            .only => |list| std.mem.findScalar(App, list, app) != null,
            .except => |list| std.mem.findScalar(App, list, app) == null,
        };
    }
};

comptime {
    const apps = @typeInfo(App).@"enum".field_names;
    const fields = @typeInfo(Base).@"struct".field_names;
    if (apps.len != fields.len) @compileError("Base.App must name every field of Base, in order");
    for (apps, fields) |app, field| {
        if (!std.mem.eql(u8, app, field)) @compileError("Base.App must name every field of Base, in order");
    }
}

/// The `apps` chosen, each from its `from(theme)`, with `fonts` wherever an app has fonts:
/// every family for apps taking fallbacks, the first for apps taking one, and the size for
/// terminals, notifications, the launcher and GTK.
pub fn from(theme: kosm.Theme, comptime fonts: Fonts, apps: Apps) Base {
    if (fonts.families.len == 0) @compileError("the base needs at least one font family");
    const main = fonts.families[0];
    var base: Base = .{
        .adwsteamgtk = if (apps.has(.adwsteamgtk)) kosm_adwsteamgtk.from(theme) else null,
        .blender = if (apps.has(.blender)) kosm_blender.from(theme) else null,
        .counter_strike = if (apps.has(.counter_strike)) kosm_counter_strike.from(theme) else null,
        .counter_strike_2 = if (apps.has(.counter_strike_2)) kosm_counter_strike_2.from(theme) else null,
        .darkreader = if (apps.has(.darkreader)) kosm_darkreader.from(theme) else null,
        .dunst = if (apps.has(.dunst)) kosm_dunst.from(theme) else null,
        .equibop = if (apps.has(.equibop)) kosm_equibop.from(theme) else null,
        .fontconfig = if (apps.has(.fontconfig)) kosm_fontconfig.from(theme) else null,
        .foot = if (apps.has(.foot)) kosm_foot.from(theme) else null,
        .ghostty = if (apps.has(.ghostty)) kosm_ghostty.from(theme) else null,
        .gtk = if (apps.has(.gtk)) kosm_gtk.from(theme) else null,
        .hyprland = if (apps.has(.hyprland)) kosm_hyprland.from(theme) else null,
        .hyprmouse = if (apps.has(.hyprmouse)) kosm_hyprmouse.from(theme) else null,
        .hyprtoolkit = if (apps.has(.hyprtoolkit)) kosm_hyprtoolkit.from(theme) else null,
        .kde = if (apps.has(.kde)) kosm_kde.from(theme) else null,
        .kitty = if (apps.has(.kitty)) kosm_kitty.from(theme) else null,
        .nvim = if (apps.has(.nvim)) kosm_nvim.from(theme) else null,
        .ohmyposh = if (apps.has(.ohmyposh)) kosm_ohmyposh.from(theme) else null,
        .qtct = if (apps.has(.qtct)) kosm_qtct.from(theme) else null,
        .tuios = if (apps.has(.tuios)) kosm_tuios.from(theme) else null,
        .vicinae = if (apps.has(.vicinae)) kosm_vicinae.from(theme) else null,
        .zen = if (apps.has(.zen)) kosm_zen.from(theme) else null,
    };
    if (base.counter_strike) |*counter_strike| counter_strike.font = main;
    if (base.counter_strike_2) |*counter_strike_2| counter_strike_2.font = main;
    if (base.dunst) |*dunst| dunst.global.font = .{ .families = fonts.families, .size = fonts.size };
    if (base.equibop) |*equibop| equibop.font = main;
    if (base.fontconfig) |*fontconfig| {
        fontconfig.sans_serif = fonts.families;
        fontconfig.serif = fonts.families;
        fontconfig.monospace = fonts.families;
    }
    if (base.foot) |*foot| foot.main.font = comptime footFonts(fonts);
    if (base.ghostty) |*ghostty| {
        ghostty.font_family = fonts.families;
        ghostty.font_size = fonts.size;
    }
    if (base.gtk) |*gtk| {
        const font = comptime std.fmt.comptimePrint("{s} {d}", .{ main, fonts.size });
        gtk.settings.gtk_font_name = font;
        gtk.settings.monospace_font_name = font;
        gtk.settings.document_font_name = font;
    }
    if (base.hyprland) |*hyprland| hyprland.misc.font_family = comptime pangoFamilies(fonts.families);
    if (base.hyprmouse) |*hyprmouse| hyprmouse.font = main;
    if (base.hyprtoolkit) |*hyprtoolkit| {
        hyprtoolkit.font_family = main;
        hyprtoolkit.font_family_monospace = main;
    }
    if (base.kitty) |*kitty| {
        kitty.fonts.font_family = .{ .family = main };
        kitty.fonts.font_size = fonts.size;
    }
    if (base.vicinae) |*vicinae| {
        vicinae.font_family = main;
        vicinae.font_size = fonts.size;
    }
    return base;
}

/// foot's fonts: every family at the size, in fallback order.
fn footFonts(comptime fonts: Fonts) []const kosm_foot.App.values.Font {
    var list: [fonts.families.len]kosm_foot.App.values.Font = undefined;
    for (fonts.families, &list) |family, *font| font.* = .{ .family = family, .size = fonts.size };
    const final = list;
    return &final;
}

/// The families as one Pango list, `Main, Fallback`.
fn pangoFamilies(comptime families: []const []const u8) []const u8 {
    var list: []const u8 = families[0];
    for (families[1..]) |family| list = list ++ ", " ++ family;
    return list;
}

const testing = std.testing;
const adapters = blk: {
    var list: []const kosm.Adapter = &.{};
    for (.{ kosm_adwsteamgtk, kosm_blender, kosm_counter_strike, kosm_counter_strike_2, kosm_darkreader, kosm_dunst, kosm_equibop, kosm_fontconfig, kosm_foot, kosm_ghostty, kosm_gtk, kosm_hyprland, kosm_hyprmouse, kosm_hyprtoolkit, kosm_kde, kosm_kitty, kosm_nvim, kosm_ohmyposh, kosm_qtct, kosm_tuios, kosm_vicinae, kosm_zen }) |package| {
        for (@typeInfo(package).@"struct".decl_names) |declaration| {
            if (@TypeOf(@field(package, declaration)) != kosm.Adapter) continue;
            const adapter = @field(package, declaration);
            for (list) |known| {
                if (std.mem.eql(u8, known.name, adapter.name)) break;
            } else list = list ++ .{adapter};
        }
    }
    break :blk list;
};

/// The files apps edit in place, which a real setup has and a temp home must be given.
const existing = [_]struct { []const u8, []const u8 }{
    .{ ".local/share/Steam/steamapps/common/Half-Life/valve/resource/TrackerScheme.res", "Scheme\n{\n\tColors\n\t{\n" ++ scheme_colors ++ "\t}\n\tFonts\n\t{\n\t\t\"Default\" { \"1\" { \"name\" \"Tahoma\" } }\n\t}\n}\n" },
    .{ ".config/darkreader/Dark-Reader-Settings.json", "{\"theme\": {\"darkSchemeBackgroundColor\": \"#181a1b\", \"darkSchemeTextColor\": \"#e8e6e3\", \"lightSchemeBackgroundColor\": \"#dcdad7\", \"lightSchemeTextColor\": \"#181a1b\", \"selectionColor\": \"auto\", \"scrollbarColor\": \"auto\"}}\n" },
    .{ ".config/hypr/hyprmouse.conf", "font = Sans\nfont_size = 25\nbackground_color = #000000\ngrid_color = #000000\ndot_color = #000000\ntext_color = #000000\ntext_outline_color = #000000\nbackground_opacity = 1\n" },
    .{ ".config/oh-my-posh/config.json", "{\"palette\": {}}\n" },
    .{ ".config/qt5ct/qt5ct.conf", "[Appearance]\ncolor_scheme_path=/usr/share/qt5ct/colors/airy.conf\ncustom_palette=false\n" },
    .{ ".config/qt6ct/qt6ct.conf", "[Appearance]\ncolor_scheme_path=/usr/share/qt6ct/colors/airy.conf\ncustom_palette=false\n" },
    .{ ".config/tuios/config.toml", "[appearance]\ntheme = \"default\"\n" },
    .{ ".zen/test.Default/prefs.js", "user_pref(\"browser.startup.page\", 3);\n" },
    .{ ".config/vicinae/settings.json", "{\"font\": {\"normal\": {\"family\": \"auto\", \"size\": 10.5}}, \"theme\": {\"dark\": {\"name\": \"vicinae-dark\"}}}\n" },
};

const scheme_colors = blk: {
    var lines: []const u8 = "";
    for (.{ "BaseText", "BrightBaseText", "SelectedText", "DimBaseText", "LabelDimText", "ControlText", "BrightControlText", "DisabledText1", "DimListText", "ControlBG", "ControlDarkBG", "WindowBG", "SelectionBG", "SelectionBG2", "ListBG", "TitleText", "TitleDimText", "SliderTickColor", "SliderTrackColor", "BorderBright", "BorderDark", "BorderSelection" }) |key| {
        lines = lines ++ "\t\t\"" ++ key ++ "\"\t\"0 0 0 255\"\n";
    }
    break :blk lines;
};

/// The files a kosmos built on the base plans, in a temp home holding the files apps edit.
const Planned = struct {
    tmp: testing.TmpDir,
    arena: std.heap.ArenaAllocator,
    plan: kosm.Plan,

    fn deinit(planned: *Planned) void {
        planned.plan.deinit();
        planned.arena.deinit();
        planned.tmp.cleanup();
    }

    fn has(planned: *const Planned, display_path: []const u8) bool {
        for (planned.plan.files.items) |file| {
            if (std.mem.eql(u8, file.display_path, display_path)) return true;
        }
        return false;
    }
};

fn planOf(kosmos: Base, planned: *Planned) !void {
    planned.* = .{ .tmp = testing.tmpDir(.{}), .arena = .init(testing.allocator), .plan = .init(testing.allocator, testing.io) };
    errdefer planned.deinit();
    for (existing) |file| {
        if (std.fs.path.dirname(file[0])) |directory| try planned.tmp.dir.createDirPath(testing.io, directory);
        try planned.tmp.dir.writeFile(testing.io, .{ .sub_path = file[0], .data = file[1] });
    }
    const home_buffer = try planned.arena.allocator().alloc(u8, std.Io.Dir.max_path_bytes);
    var diagnostics: kosm.Diagnostics = .{};
    var warnings: kosm.Warnings = .init(planned.arena.allocator());
    var output: kosm.Output = .{
        .allocator = planned.arena.allocator(),
        .home = home_buffer[0..try planned.tmp.dir.realPath(testing.io, home_buffer)],
        .adapters = adapters,
        .plan = &planned.plan,
        .diagnostics = &diagnostics,
        .warnings = &warnings,
        .app = "",
        .kosmos = "krystallos",
    };
    inline for (@typeInfo(Base).@"struct".field_names) |name| {
        if (@field(kosmos, name)) |app| {
            output.app = name;
            app.apply(&output) catch |err| {
                std.debug.print("{s}: {s}: {s}\n", .{ name, diagnostics.file, diagnostics.message() });
                return err;
            };
        }
    }
}

const test_palette: kosm.Palette = .{ .black = kosm.hex("041c26"), .white = kosm.hex("a3c5cc"), .cyan = kosm.hex("2e9990") };
const test_fonts: Fonts = .{ .families = &.{ "Maple Mono", "Noto Sans" }, .size = 13 };

test "a kosmos of a palette and two overrides rices every app through the base" {
    var kosmos = from(.from(test_palette, .dark), test_fonts, .{ .except = &.{.counter_strike_2} });
    kosmos.kitty.?.fonts.font_size = 14;
    var planned: Planned = undefined;
    try planOf(kosmos, &planned);
    defer planned.deinit();

    try testing.expect(planned.plan.files.items.len >= @typeInfo(Base).@"struct".field_names.len - 1);
    for (planned.plan.files.items) |file| {
        if (std.mem.eql(u8, file.display_path, "~/.config/kitty/kosm.conf"))
            try testing.expect(std.mem.indexOf(u8, file.new, "font_size 14\n") != null);
        try testing.expect(std.mem.indexOf(u8, file.display_path, "42-repl-global") == null);
    }
}

test "the theme's name and file naming reach the apps whose programs pick files by name" {
    var theme: kosm.Theme = .from(test_palette, .dark);
    theme.name = "Krystallos";
    theme.files = .per_kosmos;
    const kosmos = from(theme, test_fonts, .{ .only = &.{ .kde, .blender } });
    var planned: Planned = undefined;
    try planOf(kosmos, &planned);
    defer planned.deinit();

    try testing.expect(planned.has("~/.local/share/color-schemes/krystallos.colors"));
    try testing.expect(planned.has("~/.config/blender/5.2/scripts/presets/interface_theme/krystallos.xml"));
    for (planned.plan.files.items) |file| {
        if (std.mem.endsWith(u8, file.display_path, ".colors"))
            try testing.expect(std.mem.indexOf(u8, file.new, "Name=Krystallos\n") != null);
    }
}

test "a kosmos enabling two apps plans only their files" {
    const kosmos = from(.from(test_palette, .dark), test_fonts, .{ .only = &.{ .kitty, .ghostty, .kitty } });
    var planned: Planned = undefined;
    try planOf(kosmos, &planned);
    defer planned.deinit();

    try testing.expectEqual(2, planned.plan.files.items.len);
    try testing.expect(planned.has("~/.config/kitty/kosm.conf"));
    try testing.expect(planned.has("~/.config/ghostty/kosm"));
}

test "apps left out are null" {
    const all = from(.from(test_palette, .dark), test_fonts, .all);
    const none = from(.from(test_palette, .dark), test_fonts, .none);
    const except = from(.from(test_palette, .dark), test_fonts, .{ .except = &.{ .zen, .kitty } });
    inline for (@typeInfo(Base).@"struct".field_names) |name| {
        try testing.expect(@field(all, name) != null);
        try testing.expect(@field(none, name) == null);
        const left_out = comptime std.mem.eql(u8, name, "zen") or std.mem.eql(u8, name, "kitty");
        try testing.expectEqual(left_out, @field(except, name) == null);
    }
}

test "fonts reach every app that has them" {
    const base = from(kosm.Theme.from(.{ .black = kosm.hex("000000"), .white = kosm.hex("ffffff") }, .dark), test_fonts, .all);
    try testing.expectEqualStrings("Maple Mono, Noto Sans", base.hyprland.?.misc.font_family.?);
    try testing.expectEqual(2, base.foot.?.main.font.?.len);
    try testing.expectEqualStrings("Noto Sans", base.foot.?.main.font.?[1].family);
    try testing.expectEqual(13, base.vicinae.?.font_size.?);
    try testing.expectEqualStrings("Maple Mono", base.counter_strike.?.font.?);
}
