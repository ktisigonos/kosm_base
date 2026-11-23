//! What makes the base look nice: a theme, fonts, the shared values, and a tweak of the
//! base's apps. A look builds no apps, so it works on any base holding the official one.

const Look = @This();

const kosm = @import("kosm");
const Base = @import("Base.zig");
const Fonts = @import("Fonts.zig");
const Values = @import("Values.zig");
const ImageOptions = @import("ImageOptions.zig");

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

/// How far Hyprland's blur spreads, as a Gaussian's standard deviation in screen pixels: its
/// dual Kawase blur roughly doubles its reach with every pass after the first.
fn blurSpread(size: u32, passes: u32) f64 {
    const doublings: f64 = @floatFromInt(@max(passes, 1) - 1);
    return @as(f64, @floatFromInt(size)) * @exp2(doublings);
}

/// Halvings in the search for the least blur that reads; 6 leave under 2% of the range.
const blur_search_steps = 6;

/// `look` worn in colors taken from `image`, with its shared values derived from it, each
/// within its range in `options`: how translucent and blurred windows are from how readable
/// text stays over the image, the gaps from how busy it is, rounding, borders, padding and
/// shadows from how soft it is. The look's fonts, tweak and every other value stay; assign any
/// value afterwards to override it.
pub fn fromImage(look: Look, image: kosm.Image, options: ImageOptions) kosm.Image.Error!Look {
    var theme: kosm.Theme = .from(try image.themeInput(options.colors));
    const surface = try image.surface(options.measure);
    const window: kosm.Image.Window = .{ .background = theme.roles.background, .foreground = theme.roles.foreground };
    const translucency = try Translucency.pick(image, window, options);
    theme.background_alpha = translucency.alpha;

    var result = look;
    result.theme = theme;
    const values = &result.values;
    values.blur = .{ .size = translucency.size, .passes = translucency.passes };
    values.rounding = options.rounding.wholeAt(surface.softness);
    values.rounding_power = options.rounding_power.at(1 - surface.softness);
    values.gaps = .{
        .inner = options.gaps_inner.wholeAt(1 - surface.detail),
        .outer = options.gaps_outer.wholeAt(1 - surface.detail),
    };
    values.border_size = options.border_size.wholeAt(1 - surface.softness);
    values.padding = options.padding.wholeAt(surface.softness);
    values.shadow = .{
        .range = options.shadow_range.wholeAt(surface.softness),
        .render_power = options.shadow_render_power.wholeAt(1 - surface.softness),
    };
    return result;
}

/// The background alpha and blur `fromImage` picks.
const Translucency = struct {
    alpha: f64,
    size: u32,
    passes: u32,

    /// The lowest alpha in range at which the strongest blur in range reads, then the least
    /// blur reading at it. If none reads within range: the highest alpha, with the strongest
    /// blur when that alpha is still see-through, else the weakest.
    fn pick(image: kosm.Image, window: kosm.Image.Window, options: ImageOptions) kosm.Image.Error!Translucency {
        const strongest = try readableAt(image, window, options, 1);
        if (strongest.alpha > options.alpha.max) {
            const strength: f64 = if (options.alpha.max < 1) 1 else 0;
            var fallback = blurAt(options, strength);
            fallback.alpha = options.alpha.max;
            return fallback;
        }
        const target = @max(strongest.alpha, options.alpha.min);
        var weakest = try readableAt(image, window, options, 0);
        if (weakest.alpha <= target) {
            weakest.alpha = target;
            return weakest;
        }
        var failing: f64 = 0;
        var passing: f64 = 1;
        for (0..blur_search_steps) |_| {
            const middle = (failing + passing) / 2;
            if ((try readableAt(image, window, options, middle)).alpha <= target) passing = middle else failing = middle;
        }
        var picked = blurAt(options, passing);
        picked.alpha = target;
        return picked;
    }

    /// The blur `strength` (0..1) of the way through both blur ranges, with its readable alpha.
    fn readableAt(image: kosm.Image, window: kosm.Image.Window, options: ImageOptions, strength: f64) kosm.Image.Error!Translucency {
        var blurred = window;
        var result = blurAt(options, strength);
        blurred.blur = blurSpread(result.size, result.passes);
        result.alpha = try image.readableAlpha(blurred, options.measure);
        return result;
    }

    fn blurAt(options: ImageOptions, strength: f64) Translucency {
        return .{ .alpha = 1, .size = options.blur_size.wholeAt(strength), .passes = options.blur_passes.wholeAt(strength) };
    }
};

const std = @import("std");
const testing = std.testing;

/// A loaded image of one gray, `side` pixels square, or noise around it when `noisy`.
fn testImage(comptime side: usize, lightness: f64, noisy: bool) kosm.Image {
    const State = struct {
        var pixels: [side * side]kosm.Color = undefined;
        var planes: [side * side]f32 = undefined;
    };
    var random: std.Random.DefaultPrng = .init(3);
    for (&State.pixels, &State.planes) |*pixel, *plane| {
        const value = if (noisy) random.random().float(f64) else lightness;
        pixel.* = .{ .lightness = value, .chroma = 0, .hue = 0 };
        plane.* = @floatCast(value);
    }
    return .{ .path = "/test.png", .pixels = &State.pixels, .width = side, .lightness = &State.planes, .lightness_width = side };
}

test "a calm, soft image gives the least alpha, no blur, round corners and wide gaps" {
    const look = try default.fromImage(testImage(32, 0.2, false), .{ .measure = .{ .screen_width = 32 } });
    try testing.expectEqual(0.6, look.theme.background_alpha);
    try testing.expectEqual(0, look.values.blur.size.?);
    try testing.expectEqual(16, look.values.rounding.?);
    try testing.expectEqual(2, look.values.rounding_power.?);
    try testing.expectEqual(6, look.values.gaps.inner.?);
    try testing.expectEqual(12, look.values.gaps.outer.?);
    try testing.expectEqual(1, look.values.border_size.?);
    try testing.expectEqual(13, look.fonts.size);
}

test "a busy image blurs as much as needed and narrows the gaps" {
    const look = try default.fromImage(testImage(64, 0, true), .{ .measure = .{ .screen_width = 64, .text_size = 4 } });
    try testing.expect(look.values.blur.size.? > 0);
    try testing.expectEqual(2, look.values.gaps.inner.?);
    try testing.expectEqual(4, look.values.gaps.outer.?);
    try testing.expect(look.theme.background_alpha >= 0.6 and look.theme.background_alpha <= 1);
}

test "a pinned range pins its value whatever the image" {
    const look = try default.fromImage(testImage(64, 0, true), .{
        .measure = .{ .screen_width = 64 },
        .alpha = .{ .min = 1, .max = 1 },
        .rounding = .{ .min = 7, .max = 7 },
    });
    try testing.expectEqual(1, look.theme.background_alpha);
    try testing.expectEqual(0, look.values.blur.size.?);
    try testing.expectEqual(7, look.values.rounding.?);
}

test "an image kosm did not load gives no look" {
    try testing.expectError(error.ImageNotLoaded, default.fromImage(.{ .path = "/a.png" }, .{}));
}
