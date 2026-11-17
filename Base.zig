//! Every official app the kosmos chose, each from a look's theme with its fonts and shared
//! values. A kosmos returns this after overriding single values.

const Base = @This();

const std = @import("std");
const kosm = @import("kosm");
const kosm_adwsteamgtk = @import("kosm_adwsteamgtk");
const kosm_blender = @import("kosm_blender");
const kosm_commet = @import("kosm_commet");
const kosm_counter_strike = @import("kosm_counter_strike");
const kosm_counter_strike_2 = @import("kosm_counter_strike_2");
const kosm_cursor = @import("kosm_cursor");
const kosm_dunst = @import("kosm_dunst");
const kosm_equibop = @import("kosm_equibop");
const kosm_fastfetch = @import("kosm_fastfetch");
const kosm_firefox = @import("kosm_firefox");
const kosm_fontconfig = @import("kosm_fontconfig");
const kosm_foot = @import("kosm_foot");
const kosm_ghostty = @import("kosm_ghostty");
const kosm_gtk = @import("kosm_gtk");
const kosm_hyprland = @import("kosm_hyprland");
const kosm_hyprmouse = @import("kosm_hyprmouse");
const kosm_hyprpaper = @import("kosm_hyprpaper");
const kosm_hyprtoolkit = @import("kosm_hyprtoolkit");
const kosm_icons = @import("kosm_icons");
const kosm_kde = @import("kosm_kde");
const kosm_kitty = @import("kosm_kitty");
const kosm_nvim = @import("kosm_nvim");
const kosm_ohmyposh = @import("kosm_ohmyposh");
const kosm_qtct = @import("kosm_qtct");
const kosm_tuios = @import("kosm_tuios");
const kosm_vicinae = @import("kosm_vicinae");
const kosm_wlr_which_key = @import("kosm_wlr_which_key");
const kosm_zen = @import("kosm_zen");

const Fonts = @import("Fonts.zig");
const Look = @import("Look.zig");
const Values = @import("Values.zig");

/// Steam's custom CSS for its Adwaita skin. null: not riced.
adwsteamgtk: ?kosm_adwsteamgtk.App,
/// Blender's interface theme preset. null: not riced.
blender: ?kosm_blender.App,
/// Commet's custom theme, selected in its preferences; needs its shared_preferences.json.
/// null: not riced.
commet: ?kosm_commet.App,
/// Counter-Strike 1.6's menu colors and font; needs the game's TrackerScheme.res. null: not riced.
counter_strike: ?kosm_counter_strike.App,
/// Counter-Strike 2's UI font. null: not riced.
counter_strike_2: ?kosm_counter_strike_2.App,
/// A cursor theme in the theme's colors (Bibata), which GTK and Hyprland pick. null: not riced.
cursor: ?kosm_cursor.App,
/// dunst's notifications. null: not riced.
dunst: ?kosm_dunst.App,
/// Equibop's QuickCSS colors and font. null: not riced.
equibop: ?kosm_equibop.App,
/// fastfetch's whole config: its layout and colors. null: not riced.
fastfetch: ?kosm_fastfetch.App,
/// Pages in Firefox-based browsers, in the colors and font, through kosm's extension; Kosm Live
/// in every Zen profile, which also makes `zen`'s prefs live. null: not riced.
firefox: ?kosm_firefox.App,
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
/// hyprpaper's wallpapers, which the kosmos sets; with none, nothing is written. null: not riced.
hyprpaper: ?kosm_hyprpaper.App,
/// hyprtoolkit apps' colors and fonts. null: not riced.
hyprtoolkit: ?kosm_hyprtoolkit.App,
/// An icon theme in the theme's colors (BeautyLine), which GTK, KDE, Qt and hyprtoolkit pick.
/// null: not riced.
icons: ?kosm_icons.App,
/// KDE's color scheme and kdeglobals. null: not riced.
kde: ?kosm_kde.App,
/// kitty's colors and font. null: not riced.
kitty: ?kosm_kitty.App,
/// Neovim's base16 colors. null: not riced.
nvim: ?kosm_nvim.App,
/// Oh My Posh's whole prompt config: its layout and palette. null: not riced.
ohmyposh: ?kosm_ohmyposh.App,
/// qt5ct's and qt6ct's color schemes; needs their configs. null: not riced.
qtct: ?kosm_qtct.App,
/// tuios' theme; needs its config.toml. null: not riced.
tuios: ?kosm_tuios.App,
/// Vicinae's theme and font; needs its settings.json. null: not riced.
vicinae: ?kosm_vicinae.App,
/// wlr-which-key's colors, font and frame; needs its config.yaml. null: not riced.
wlr_which_key: ?kosm_wlr_which_key.App,
/// Zen Browser's colors, logo and prefs. null: not riced.
zen: ?kosm_zen.App,

/// One of the base's apps, named as its field.
pub const App = enum {
    adwsteamgtk,
    blender,
    commet,
    counter_strike,
    counter_strike_2,
    cursor,
    dunst,
    equibop,
    fastfetch,
    firefox,
    fontconfig,
    foot,
    ghostty,
    gtk,
    hyprland,
    hyprmouse,
    hyprpaper,
    hyprtoolkit,
    icons,
    kde,
    kitty,
    nvim,
    ohmyposh,
    qtct,
    tuios,
    vicinae,
    wlr_which_key,
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

/// The `apps` chosen, each from its `from(look.theme)`, with the look's fonts wherever an app
/// has fonts (every family for apps taking fallbacks, the first for apps taking one, and the
/// size for terminals, notifications, the launcher and GTK, moved by its deltas for menus,
/// headings and small text) and each of its values set in
/// every app having that setting; then the look's tweak.
pub fn from(comptime look: Look, apps: Apps) Base {
    return fromTheme(look, look.theme, apps);
}

/// Like `from`, with `theme` in place of the look's own, so a theme known only at run time (one
/// taken from an image in the kosmos' `Params`) wears the look's fonts, values and tweak. The
/// tweak gets the look with that theme.
pub fn fromTheme(comptime look: Look, theme: kosm.Theme, apps: Apps) Base {
    const fonts = look.fonts;
    if (fonts.families.len == 0) @compileError("the base needs at least one font family");
    const main = fonts.families[0];
    var base: Base = .{
        .adwsteamgtk = if (apps.has(.adwsteamgtk)) kosm_adwsteamgtk.from(theme) else null,
        .blender = if (apps.has(.blender)) kosm_blender.from(theme) else null,
        .commet = if (apps.has(.commet)) kosm_commet.from(theme) else null,
        .counter_strike = if (apps.has(.counter_strike)) kosm_counter_strike.from(theme) else null,
        .counter_strike_2 = if (apps.has(.counter_strike_2)) kosm_counter_strike_2.from(theme) else null,
        .cursor = if (apps.has(.cursor)) kosm_cursor.from(theme) else null,
        .dunst = if (apps.has(.dunst)) kosm_dunst.from(theme) else null,
        .equibop = if (apps.has(.equibop)) kosm_equibop.from(theme) else null,
        .fastfetch = if (apps.has(.fastfetch)) kosm_fastfetch.from(theme) else null,
        .firefox = if (apps.has(.firefox)) kosm_firefox.from(theme) else null,
        .fontconfig = if (apps.has(.fontconfig)) kosm_fontconfig.from(theme) else null,
        .foot = if (apps.has(.foot)) kosm_foot.from(theme) else null,
        .ghostty = if (apps.has(.ghostty)) kosm_ghostty.from(theme) else null,
        .gtk = if (apps.has(.gtk)) kosm_gtk.from(theme) else null,
        .hyprland = if (apps.has(.hyprland)) kosm_hyprland.from(theme) else null,
        .hyprmouse = if (apps.has(.hyprmouse)) kosm_hyprmouse.from(theme) else null,
        .hyprpaper = if (apps.has(.hyprpaper)) kosm_hyprpaper.from(theme) else null,
        .hyprtoolkit = if (apps.has(.hyprtoolkit)) kosm_hyprtoolkit.from(theme) else null,
        .icons = if (apps.has(.icons)) kosm_icons.from(theme) else null,
        .kde = if (apps.has(.kde)) kosm_kde.from(theme) else null,
        .kitty = if (apps.has(.kitty)) kosm_kitty.from(theme) else null,
        .nvim = if (apps.has(.nvim)) kosm_nvim.from(theme) else null,
        .ohmyposh = if (apps.has(.ohmyposh)) kosm_ohmyposh.from(theme) else null,
        .qtct = if (apps.has(.qtct)) kosm_qtct.from(theme) else null,
        .tuios = if (apps.has(.tuios)) kosm_tuios.from(theme) else null,
        .vicinae = if (apps.has(.vicinae)) kosm_vicinae.from(theme) else null,
        .wlr_which_key = if (apps.has(.wlr_which_key)) kosm_wlr_which_key.from(theme) else null,
        .zen = if (apps.has(.zen)) kosm_zen.from(theme) else null,
    };
    if (base.counter_strike) |*counter_strike| counter_strike.font = main;
    if (base.counter_strike_2) |*counter_strike_2| counter_strike_2.font = main;
    if (base.dunst) |*dunst| dunst.global.font = .{ .families = fonts.families, .size = fonts.size };
    if (base.equibop) |*equibop| equibop.font = main;
    if (base.firefox) |*firefox| firefox.theme.font_family = fonts.families;
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
    if (base.hyprland) |*hyprland| {
        hyprland.misc.font_family = comptime pangoFamilies(fonts.families);
        // Behind the wallpaper is the theme's background alone, so a wallpaper switch only
        // flashes that color, not Hyprland's logo and default wallpaper.
        hyprland.misc.disable_hyprland_logo = true;
        hyprland.misc.disable_splash_rendering = true;
    }
    if (base.hyprmouse) |*hyprmouse| hyprmouse.font = main;
    if (base.qtct) |*qtct| {
        qtct.fonts.general = .{ .family = main, .size = fonts.size };
        qtct.fonts.fixed = .{ .family = main, .size = fonts.size };
    }
    if (base.hyprtoolkit) |*hyprtoolkit| {
        hyprtoolkit.font_family = main;
        hyprtoolkit.font_family_monospace = main;
        hyprtoolkit.h1_size = fonts.wholePlus(fonts.deltas.heading);
        hyprtoolkit.h2_size = fonts.wholePlus(fonts.deltas.subheading);
        hyprtoolkit.h3_size = fonts.wholePlus(0);
        hyprtoolkit.font_size = fonts.wholePlus(0);
        hyprtoolkit.small_font_size = fonts.wholePlus(fonts.deltas.small);
    }
    if (base.kitty) |*kitty| {
        kitty.fonts.font_family = .{ .family = main };
        kitty.fonts.font_size = fonts.size;
    }
    if (base.vicinae) |*vicinae| {
        vicinae.font_family = main;
        vicinae.font_size = fonts.size;
    }
    if (base.wlr_which_key) |*wlr_which_key| wlr_which_key.font = comptime std.fmt.comptimePrint("{s} {d}", .{ pangoFamilies(fonts.families), fonts.plus(fonts.deltas.large) });
    // Kosm Live, which firefox installs into Zen's profiles, sets their prefs in a running Zen.
    if (base.zen) |*zen| if (zen.profile) |*profile| if (base.firefox != null) {
        profile.live = true;
    };
    base.setValues(look.values, theme);
    if (look.tweak) |tweak| {
        var worn = look;
        worn.theme = theme;
        tweak(&base, worn);
    }
    return base;
}

/// Sets each value that is not null in every app having that setting. With no `icon_theme`
/// or cursor name, the icons and cursor apps' themes are picked; an inactive border left null
/// follows the active one.
fn setValues(base: *Base, values: Values, theme: kosm.Theme) void {
    const icon_theme = values.icon_theme orelse if (base.icons) |icons| icons.themeName() else null;
    const cursor_theme = values.cursor.name orelse if (base.cursor) |cursor| cursor.themeName() else null;
    if (base.cursor) |*cursor| if (values.cursor.size) |size| {
        cursor.size = size;
    };
    const active_border = values.borders.active;
    const inactive_border = values.borders.inactive orelse
        if (active_border) |active| theme.variations.state.inactive.apply(active) else null;
    if (base.dunst) |*dunst| {
        if (values.border_size) |size| dunst.global.frame_width = size;
        if (values.rounding) |rounding| dunst.global.corner_radius = rounding;
        if (active_border) |color| {
            dunst.urgency_low.frame_color = color;
            dunst.urgency_normal.frame_color = color;
        }
    }
    if (base.ghostty) |*ghostty| {
        if (values.padding) |padding| {
            ghostty.window_padding_x = .all(padding);
            ghostty.window_padding_y = .all(padding);
        }
        if (values.blur) |blur| ghostty.background_blur = .{ .boolean = blur };
    }
    if (base.foot) |*foot| if (values.padding) |padding| {
        foot.main.pad = .all(padding);
    };
    if (base.kitty) |*kitty| {
        if (values.padding) |padding| kitty.window.window_padding_width = .all(@floatFromInt(padding));
        if (values.editor) |editor| kitty.advanced.editor = editor;
        if (active_border) |color| kitty.window.active_border_color = .{ .color = color };
        if (inactive_border) |color| kitty.window.inactive_border_color = color;
    }
    if (base.gtk) |*gtk| {
        if (icon_theme) |name| gtk.settings.gtk_icon_theme_name = name;
        if (cursor_theme) |name| gtk.settings.gtk_cursor_theme_name = name;
        if (values.cursor.size) |size| gtk.settings.gtk_cursor_theme_size = size;
    }
    if (base.hyprtoolkit) |*hyprtoolkit| {
        if (icon_theme) |name| hyprtoolkit.icon_theme = name;
        if (values.rounding) |rounding| {
            hyprtoolkit.rounding_large = rounding;
            hyprtoolkit.rounding_small = rounding / 2;
        }
    }
    if (base.kde) |*kde| if (icon_theme) |name| {
        kde.icon_theme = name;
    };
    if (base.qtct) |*qtct| qtct.icon_theme = icon_theme;
    if (base.vicinae) |*vicinae| {
        if (icon_theme) |name| vicinae.icon_theme = name;
        if (values.rounding) |rounding| vicinae.rounding = rounding;
        if (values.border_size) |size| vicinae.border_width = size;
        if (values.shadow.range) |range| vicinae.shadow_size = range;
        if (values.blur) |blur| vicinae.material = if (blur) .blur else .none;
        if (active_border) |color| vicinae.colors.core.border = color;
    }
    if (base.wlr_which_key) |*wlr_which_key| {
        if (values.border_size) |size| wlr_which_key.border_width = size;
        if (values.rounding) |rounding| wlr_which_key.corner_r = rounding;
        if (active_border) |color| wlr_which_key.border = color;
    }
    if (base.zen) |*zen| {
        if (active_border) |color| zen.border = color;
        if (zen.profile) |*profile| if (values.rounding) |rounding| {
            profile.prefs.zen.theme.border_radius = @intCast(rounding);
        };
    }
    if (base.hyprland) |*hyprland| setHyprland(hyprland, values, cursor_theme);
}

fn setHyprland(hyprland: *kosm_hyprland.App, values: Values, cursor_theme: ?[]const u8) void {
    if (values.border_size) |size| hyprland.general.border_size = size;
    if (values.borders.active) |color| hyprland.general.col.active_border = .solid(color);
    if (values.borders.inactive) |color| hyprland.general.col.inactive_border = .solid(color);
    if (values.blur) |blur| hyprland.decoration.blur.enabled = blur;
    if (values.gaps.inner) |inner| hyprland.general.gaps_in = .all(inner);
    if (values.gaps.outer) |outer| hyprland.general.gaps_out = .all(outer);
    if (values.rounding) |rounding| hyprland.decoration.rounding = rounding;
    if (values.rounding_power) |power| hyprland.decoration.rounding_power = power;
    if (values.shadow.range) |range| hyprland.decoration.shadow.range = range;
    if (values.shadow.render_power) |power| hyprland.decoration.shadow.render_power = power;
    if (cursor_theme) |name| hyprland.cursor_theme = name;
    if (values.cursor.size) |size| hyprland.cursor_size = size;
    if (values.keyboard) |keyboard| hyprland.keyboard = keyboard;
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
    for (.{ kosm_adwsteamgtk, kosm_blender, kosm_commet, kosm_counter_strike, kosm_counter_strike_2, kosm_cursor, kosm_dunst, kosm_equibop, kosm_fastfetch, kosm_firefox, kosm_fontconfig, kosm_foot, kosm_ghostty, kosm_gtk, kosm_hyprland, kosm_hyprmouse, kosm_hyprpaper, kosm_hyprtoolkit, kosm_icons, kosm_kde, kosm_kitty, kosm_nvim, kosm_ohmyposh, kosm_qtct, kosm_tuios, kosm_vicinae, kosm_wlr_which_key, kosm_zen }) |package| {
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
    .{ ".config/hypr/hyprmouse.conf", "font = Sans\nfont_size = 25\nbackground_color = #000000\ngrid_color = #000000\ndot_color = #000000\ntext_color = #000000\ntext_outline_color = #000000\nbackground_opacity = 1\n" },
    .{ ".config/qt5ct/qt5ct.conf", "[Appearance]\ncolor_scheme_path=/usr/share/qt5ct/colors/airy.conf\ncustom_palette=false\nicon_theme=breeze\n\n[Fonts]\nfixed=\"Sans,10\"\ngeneral=\"Sans,10\"\n" },
    .{ ".config/qt6ct/qt6ct.conf", "[Appearance]\ncolor_scheme_path=/usr/share/qt6ct/colors/airy.conf\ncustom_palette=false\nicon_theme=breeze\n\n[Fonts]\nfixed=\"Sans,10\"\ngeneral=\"Sans,10\"\n" },
    .{ ".config/tuios/config.toml", "[appearance]\ntheme = \"default\"\n" },
    .{ ".zen/test.Default/prefs.js", "user_pref(\"browser.startup.page\", 3);\n" },
    .{ ".zen/test.Default/zen-themes.json", "{\"kosm\": {\"id\": \"kosm\", \"preferences\": \"preferences.json\", \"enabled\": true}}\n" },
    // Blender writes its theme into every version it has run, found by its config files.
    .{ ".config/blender/5.2/config/bookmarks.txt", "" },
    .{ ".var/app/chat.commet.commetapp/data/commet/shared_preferences.json", "{\"flutter.app_theme\":\"dark\"}" },
    .{ ".config/wlr-which-key/config.yaml", "font: Sans 12\nbackground: \"#000000\"\ncolor: \"#000000\"\nborder: \"#000000\"\nborder_width: 1\ncorner_r: 0\nmenu:\n  - key: \"a\"\n    desc: A\n    cmd: a\n" },
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
const test_look: Look = .{ .theme = .from(.{ .palette = test_palette, .mode = .dark }), .fonts = test_fonts };

test "a kosmos of a palette and two overrides rices every app through the base" {
    var kosmos = from(test_look, .{ .except = &.{.counter_strike_2} });
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
    const named: Look = comptime blk: {
        var look = test_look;
        look.theme.name = "Krystallos";
        look.theme.files = .per_kosmos;
        break :blk look;
    };
    const kosmos = from(named, .{ .only = &.{ .kde, .blender } });
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
    const kosmos = from(test_look, .{ .only = &.{ .kitty, .ghostty, .kitty } });
    var planned: Planned = undefined;
    try planOf(kosmos, &planned);
    defer planned.deinit();

    try testing.expectEqual(2, planned.plan.files.items.len);
    try testing.expect(planned.has("~/.config/kitty/kosm.conf"));
    try testing.expect(planned.has("~/.config/ghostty/kosm"));
}

test "apps left out are null" {
    const all = from(test_look, .all);
    const none = from(test_look, .none);
    const except = from(test_look, .{ .except = &.{ .zen, .kitty } });
    inline for (@typeInfo(Base).@"struct".field_names) |name| {
        try testing.expect(@field(all, name) != null);
        try testing.expect(@field(none, name) == null);
        const left_out = comptime std.mem.eql(u8, name, "zen") or std.mem.eql(u8, name, "kitty");
        try testing.expectEqual(left_out, @field(except, name) == null);
    }
}

test "fonts reach every app that has them" {
    const base = from(test_look, .all);
    try testing.expectEqualStrings("Maple Mono, Noto Sans", base.hyprland.?.misc.font_family.?);
    try testing.expect(base.hyprland.?.misc.disable_hyprland_logo.?);
    try testing.expectEqual(2, base.foot.?.main.font.?.len);
    try testing.expectEqualStrings("Noto Sans", base.foot.?.main.font.?[1].family);
    try testing.expectEqual(13, base.vicinae.?.font_size.?);
    try testing.expectEqualStrings("Maple Mono, Noto Sans 16", base.wlr_which_key.?.font.?);
    try testing.expectEqual(25, base.hyprtoolkit.?.h1_size.?);
    try testing.expectEqual(9, base.hyprtoolkit.?.small_font_size.?);
    try testing.expectEqualStrings("Maple Mono", base.counter_strike.?.font.?);
    try testing.expectEqual(kosm_qtct.App.Font{ .family = "Maple Mono", .size = 13 }, base.qtct.?.fonts.fixed.?);
}

test "role sizes follow the size and the look's deltas, rounded for apps taking whole points" {
    const look: Look = comptime blk: {
        var changed = test_look;
        changed.fonts.size = 10.5;
        changed.fonts.deltas.large = 4;
        changed.fonts.deltas.subheading = 0;
        break :blk changed;
    };
    const base = from(look, .{ .only = &.{ .wlr_which_key, .hyprtoolkit } });
    try testing.expectEqualStrings("Maple Mono, Noto Sans 14.5", base.wlr_which_key.?.font.?);
    try testing.expectEqual(23, base.hyprtoolkit.?.h1_size.?);
    try testing.expectEqual(11, base.hyprtoolkit.?.h2_size.?);
    try testing.expectEqual(7, base.hyprtoolkit.?.small_font_size.?);
}

test "with firefox, pages get the look's fonts and Zen's prefs go live" {
    const base = from(test_look, .all);
    try testing.expectEqualStrings("Noto Sans", base.firefox.?.theme.font_family.?[1]);
    try testing.expect(base.zen.?.profile.?.live);
    try testing.expect(!from(test_look, .{ .except = &.{.firefox} }).zen.?.profile.?.live);
}

test "each shared value reaches every app having that setting" {
    const look: Look = comptime blk: {
        var look = test_look;
        look.values = .{
            .border_size = 2,
            .borders = .{ .active = kosm.hex("808080") },
            .rounding = 12,
            .rounding_power = 3,
            .gaps = .{ .inner = 4, .outer = 8 },
            .padding = 10,
            .shadow = .{ .range = 15, .render_power = 3 },
            .cursor = .{ .name = "Bibata", .size = 24 },
            .icon_theme = "Papirus",
            .keyboard = .{ .layouts = &.{.{ .layout = "us" }} },
            .editor = "nvim",
            .blur = false,
        };
        break :blk look;
    };
    const base = from(look, .all);
    const hyprland = base.hyprland.?;
    const gray = kosm.hex("808080");
    try testing.expectEqual(kosm_hyprland.values.Gradient.solid(gray), hyprland.general.col.active_border.?);
    try testing.expect(!hyprland.decoration.blur.enabled.?);
    try testing.expectEqual(gray, base.kitty.?.window.active_border_color.?.color);
    try testing.expectEqual(look.theme.variations.state.inactive.apply(gray), base.kitty.?.window.inactive_border_color.?);
    try testing.expectEqual(gray, base.wlr_which_key.?.border.?);
    try testing.expectEqual(gray, base.zen.?.border.?);
    try testing.expectEqual(gray, base.dunst.?.urgency_normal.frame_color.?);
    try testing.expectEqual(look.theme.roles.@"error", base.dunst.?.urgency_critical.frame_color.?);
    try testing.expectEqual(2, base.dunst.?.global.frame_width.?);
    try testing.expectEqual(12, base.dunst.?.global.corner_radius.?);
    const vicinae = base.vicinae.?;
    try testing.expectEqual(gray, vicinae.colors.core.border.?);
    try testing.expectEqual(12, vicinae.rounding.?);
    try testing.expectEqual(2, vicinae.border_width.?);
    try testing.expectEqual(15, vicinae.shadow_size.?);
    try testing.expectEqual(.none, vicinae.material.?);
    try testing.expect(!base.ghostty.?.background_blur.?.boolean);
    try testing.expectEqual(2, hyprland.general.border_size.?);
    try testing.expectEqual(kosm_hyprland.values.CssGap.all(4), hyprland.general.gaps_in.?);
    try testing.expectEqual(kosm_hyprland.values.CssGap.all(8), hyprland.general.gaps_out.?);
    try testing.expectEqual(12, hyprland.decoration.rounding.?);
    try testing.expectEqual(3, hyprland.decoration.rounding_power.?);
    try testing.expectEqual(15, hyprland.decoration.shadow.range.?);
    try testing.expectEqual(3, hyprland.decoration.shadow.render_power.?);
    try testing.expectEqualStrings("Bibata", hyprland.cursor_theme.?);
    try testing.expectEqual(24, hyprland.cursor_size.?);
    try testing.expectEqualStrings("us", hyprland.keyboard.?.layouts[0].layout);
    try testing.expectEqual(12, base.hyprtoolkit.?.rounding_large.?);
    try testing.expectEqual(6, base.hyprtoolkit.?.rounding_small.?);
    try testing.expectEqualStrings("Papirus", base.hyprtoolkit.?.icon_theme.?);
    try testing.expectEqual(12, base.zen.?.profile.?.prefs.zen.theme.border_radius.?);
    try testing.expectEqual(2, base.wlr_which_key.?.border_width.?);
    try testing.expectEqual(12, base.wlr_which_key.?.corner_r.?);
    try testing.expectEqual(kosm_ghostty.values.Padding.all(10), base.ghostty.?.window_padding_x.?);
    try testing.expectEqual(kosm_ghostty.values.Padding.all(10), base.ghostty.?.window_padding_y.?);
    try testing.expectEqual(kosm_foot.App.values.Pad.all(10), base.foot.?.main.pad.?);
    try testing.expectEqual(kosm_kitty.values.Edges.all(10), base.kitty.?.window.window_padding_width.?);
    try testing.expectEqualStrings("nvim", base.kitty.?.advanced.editor.?);
    try testing.expectEqualStrings("Papirus", base.gtk.?.settings.gtk_icon_theme_name.?);
    try testing.expectEqualStrings("Papirus", base.kde.?.icon_theme.?);
    try testing.expectEqualStrings("Papirus", base.vicinae.?.icon_theme.?);
    try testing.expectEqualStrings("Bibata", base.gtk.?.settings.gtk_cursor_theme_name.?);
    try testing.expectEqual(24, base.gtk.?.settings.gtk_cursor_theme_size.?);
}

test "an inactive border set goes to Hyprland and kitty, and blur on picks Vicinae's blur" {
    const look: Look = comptime blk: {
        var look = test_look;
        look.values.borders.inactive = kosm.hex("282e22");
        look.values.blur = true;
        break :blk look;
    };
    const base = from(look, .all);
    try testing.expectEqual(kosm_hyprland.values.Gradient.solid(kosm.hex("282e22")), base.hyprland.?.general.col.inactive_border.?);
    try testing.expectEqual(kosm.hex("282e22"), base.kitty.?.window.inactive_border_color.?);
    try testing.expectEqual(look.theme.roles.accent, base.kitty.?.window.active_border_color.?.color);
    try testing.expectEqual(.blur, base.vicinae.?.material.?);
}

test "values left null leave every app's setting unwritten" {
    const base = from(test_look, .all);
    try testing.expectEqual(null, base.hyprland.?.general.border_size);
    try testing.expectEqual(null, base.hyprland.?.cursor_size);
    try testing.expectEqual(null, base.cursor.?.size);
    try testing.expectEqual(null, base.kitty.?.window.window_padding_width);
    try testing.expectEqual(null, base.hyprland.?.general.col.inactive_border);
    try testing.expectEqual(null, base.hyprland.?.decoration.blur.enabled);
    try testing.expectEqual(null, base.vicinae.?.rounding);
    try testing.expectEqual(null, base.vicinae.?.material);
    try testing.expectEqual(null, base.dunst.?.global.corner_radius);
    try testing.expectEqualStrings("kosm", base.gtk.?.settings.gtk_icon_theme_name.?);
    const without_icons = from(test_look, .{ .except = &.{.icons} });
    try testing.expectEqual(null, without_icons.gtk.?.settings.gtk_icon_theme_name);
    try testing.expectEqual(null, without_icons.kde.?.icon_theme);
}

test "with no cursor name, GTK and Hyprland pick the cursor app's theme, and the size reaches it" {
    const base = from(test_look, .all);
    try testing.expectEqualStrings("kosm_cursor", base.gtk.?.settings.gtk_cursor_theme_name.?);
    try testing.expectEqualStrings("kosm_cursor", base.hyprland.?.cursor_theme.?);
    const sized: Look = comptime blk: {
        var look = test_look;
        look.values.cursor.size = 32;
        break :blk look;
    };
    try testing.expectEqual(32, from(sized, .all).cursor.?.size.?);
    const without_cursor = from(test_look, .{ .except = &.{.cursor} });
    try testing.expectEqual(null, without_cursor.hyprland.?.cursor_theme);
}

test "with no icon_theme, GTK, KDE, qt5ct, qt6ct, hyprtoolkit and Vicinae pick the icons app's theme" {
    const base = from(test_look, .all);
    try testing.expectEqualStrings("kosm", base.qtct.?.icon_theme.?);
    try testing.expectEqualStrings("kosm", base.gtk.?.settings.gtk_icon_theme_name.?);
    try testing.expectEqualStrings("kosm", base.kde.?.icon_theme.?);
    try testing.expectEqualStrings("kosm", base.hyprtoolkit.?.icon_theme.?);
    try testing.expectEqualStrings("kosm", base.vicinae.?.icon_theme.?);
}

fn testTweak(base: *Base, look: Look) void {
    // Runs after the values were handed out, so it sees and can override them.
    base.ghostty.?.window_padding_x = .all(look.values.padding.? * 2);
}

test "the look's tweak runs after the fonts and values are handed out" {
    const look: Look = comptime blk: {
        var look = test_look;
        look.values.padding = 10;
        look.tweak = testTweak;
        break :blk look;
    };
    const base = from(look, .{ .only = &.{.ghostty} });
    try testing.expectEqual(kosm_ghostty.values.Padding.all(20), base.ghostty.?.window_padding_x.?);
    try testing.expectEqual(kosm_ghostty.values.Padding.all(10), base.ghostty.?.window_padding_y.?);
}

fn foregroundTweak(base: *Base, look: Look) void {
    base.ghostty.?.foreground = look.theme.roles.accent;
}

test "a theme known only at run time wears the look, and its tweak sees that theme" {
    var lightness: f64 = 0.3;
    std.mem.doNotOptimizeAway(&lightness);
    const theme: kosm.Theme = .from(.{ .palette = .{
        .black = .{ .lightness = lightness, .chroma = 0, .hue = 0 },
        .white = kosm.hex("ffffff"),
        .cyan = kosm.hex("00ffff"),
    }, .mode = .dark });
    const look: Look = comptime blk: {
        var look = test_look;
        look.tweak = foregroundTweak;
        break :blk look;
    };
    const base = fromTheme(look, theme, .{ .only = &.{.ghostty} });
    try testing.expectApproxEqAbs(0.3, base.ghostty.?.background.?.lightness, 1e-9);
    try testing.expectEqualStrings("#00ffff", base.ghostty.?.foreground.?.hex().slice());
}

/// An app of a user's own, outside the official base.
const TestApp = struct {
    accent: kosm.Color,
    fn from(theme: kosm.Theme) TestApp {
        return .{ .accent = theme.roles.accent };
    }
};

test "a user base holds the official one beside its own apps, which take the look's accent" {
    const accented: Look = comptime blk: {
        var look = test_look;
        look.theme = .from(.{ .palette = test_palette, .mode = .dark, .roles = .{ .accent = kosm.hex("ff8000") } });
        break :blk look;
    };
    const UserBase = struct { base: Base, mine: TestApp };
    const user: UserBase = .{ .base = from(accented, .{ .only = &.{.gtk} }), .mine = .from(accented.theme) };
    try testing.expectEqual(kosm.hex("ff8000"), user.mine.accent);
    try testing.expectEqual(user.mine.accent, user.base.gtk.?.colors.accent_bg.?);
}

test "the default look is literal: pure hues and square corners" {
    const base = from(Look.default, .{ .only = &.{.hyprland} });
    try testing.expectEqual(kosm.hex("00ffff"), Look.default.theme.roles.accent);
    try testing.expectEqual(kosm.hex("000000"), Look.default.theme.roles.background);
    try testing.expectEqual(0, base.hyprland.?.decoration.rounding.?);
}
