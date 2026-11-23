//! What makes the base look nice: a theme, fonts, the shared values, and a tweak of the
//! base's apps. A look builds no apps, so it works on any base holding the official one.

const Look = @This();

const kosm = @import("kosm");
const Base = @import("Base.zig");
const Fonts = @import("Fonts.zig");
const Values = @import("Values.zig");
const Mapping = @import("Mapping.zig");

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

/// `look` worn in `theme`, with its shared values derived from the theme's traits as
/// `mapping` says: translucency and blur from readability, shapes, gaps and glow from what the
/// source is like. A theme without traits (made by hand) is worn with the look's values as
/// they are. Fonts, tweak and every value not derived stay; assign any afterwards to override.
pub fn fromTraits(look: Look, theme: kosm.Theme, mapping: Mapping) Look {
    var result = look;
    result.theme = theme;
    const traits = theme.traits orelse return result;
    const translucency = Translucency.pick(traits, mapping);
    result.theme.background_alpha = translucency.alpha;
    const values = &result.values;
    values.blur.size = translucency.size;
    values.blur.passes = translucency.passes;
    values.rounding = mapping.rounding.wholeAt(traits);
    // Tenths: a finer power looks no different and churns the config on every new picture.
    values.rounding_power = @round(mapping.rounding_power.at(traits) * 10) / 10;
    values.gaps = .{ .inner = mapping.gaps_inner.wholeAt(traits), .outer = mapping.gaps_outer.wholeAt(traits) };
    values.border_size = mapping.border_size.wholeAt(traits);
    values.padding = mapping.padding.wholeAt(traits);
    values.shadow = .{ .range = mapping.shadow_range.wholeAt(traits), .render_power = mapping.shadow_render_power.wholeAt(traits) };
    values.glow.range = mapping.glow_range.wholeAt(traits);
    values.glow.render_power = mapping.glow_render_power.wholeAt(traits);
    if (mapping.glow_color) if (traits.glow_color) |color| {
        values.glow.active = .{ .color = color };
    };
    return result;
}

/// `fromTraits` with the theme taken from `image` as `options` says, carrying its traits.
pub fn fromImage(look: Look, image: kosm.Image, options: kosm.Image.Options, mapping: Mapping) kosm.Image.Error!Look {
    return look.fromTraits(.from(try image.themeInput(options)), mapping);
}

/// The background alpha and blur `fromTraits` picks.
const Translucency = struct {
    alpha: f64,
    size: u32,
    passes: u32,

    /// The alpha `mapping.alpha` gives, with the least blur in range at which text reads at
    /// it. If none does: the alpha at which the strongest blur reads, at most the range's max,
    /// with that blur while it is still see-through, else none.
    fn pick(traits: kosm.Traits, mapping: Mapping) Translucency {
        const target = mapping.alpha.at(traits);
        const strongest = readableAt(traits, mapping, 1);
        if (strongest.alpha > target) {
            const alpha = @min(strongest.alpha, mapping.alpha.range.max);
            var fallback = blurAt(mapping, if (alpha < 1) 1 else 0);
            fallback.alpha = alpha;
            return fallback;
        }
        var weakest = readableAt(traits, mapping, 0);
        if (weakest.alpha <= target) {
            weakest.alpha = target;
            return weakest;
        }
        var failing: f64 = 0;
        var passing: f64 = 1;
        for (0..blur_search_steps) |_| {
            const middle = (failing + passing) / 2;
            if (readableAt(traits, mapping, middle).alpha <= target) passing = middle else failing = middle;
        }
        var picked = blurAt(mapping, passing);
        picked.alpha = target;
        return picked;
    }

    /// The blur `strength` (0..1) of the way through both blur ranges, with its readable alpha.
    fn readableAt(traits: kosm.Traits, mapping: Mapping, strength: f64) Translucency {
        var result = blurAt(mapping, strength);
        result.alpha = traits.readability.alphaAt(blurSpread(result.size, result.passes));
        return result;
    }

    fn blurAt(mapping: Mapping, strength: f64) Translucency {
        return .{ .alpha = 1, .size = mapping.blur_size.wholeAt(strength), .passes = mapping.blur_passes.wholeAt(strength) };
    }
};

const std = @import("std");
const testing = std.testing;

/// The default look in a theme carrying `traits`.
fn wornWith(traits: kosm.Traits, mapping: Mapping) Look {
    var input = default.theme.input;
    input.traits = traits;
    return default.fromTraits(.from(input), mapping);
}

/// Readability reading at every blur, at this alpha.
fn readableEverywhere(alpha: f64) kosm.Traits.Readability {
    return .{ .alphas = @splat(alpha) };
}

test "a crisp picture gets square corners, and a soft blurry one round corners and roomy padding" {
    const crisp = wornWith(.{ .softness = 0, .blurriness = 0 }, .{});
    try testing.expectEqual(0, crisp.values.rounding.?);
    try testing.expectEqual(4, crisp.values.rounding_power.?);
    try testing.expectEqual(3, crisp.values.border_size.?);
    const soft = wornWith(.{ .softness = 1, .blurriness = 1 }, .{});
    try testing.expectEqual(16, soft.values.rounding.?);
    try testing.expectEqual(2, soft.values.rounding_power.?);
    try testing.expectEqual(14, soft.values.padding.?);
    try testing.expectEqual(13, soft.fonts.size);
}

test "a picture that glows gets a glow in its glow's color, and one that does not gets none" {
    const neon = kosm.hex("ff00cc");
    const glowing = wornWith(.{ .glow = 1, .glow_color = neon }, .{});
    try testing.expectEqual(15, glowing.values.glow.range.?);
    try testing.expectEqual(neon, glowing.values.glow.active.?.color);
    const dull = wornWith(.{ .glow = 0 }, .{});
    try testing.expectEqual(0, dull.values.glow.range.?);
    try testing.expectEqual(null, dull.values.glow.active);
    const own_color = wornWith(.{ .glow = 1, .glow_color = neon }, .{ .glow_color = false });
    try testing.expectEqual(null, own_color.values.glow.active);
}

test "alpha follows its rule while text reads, with the least blur reading at it" {
    const calm = wornWith(.{ .readability = readableEverywhere(0.3) }, .{});
    try testing.expectApproxEqAbs(0.8, calm.theme.background_alpha, 1e-12);
    try testing.expectEqual(0, calm.values.blur.size.?);
    var readability: kosm.Traits.Readability = .{ .alphas = .{ 1, 0.95, 0.9, 0.7, 0.5 } };
    const busy = wornWith(.{ .detail = 0.5, .readability = readability }, .{});
    try testing.expectApproxEqAbs(0.9, busy.theme.background_alpha, 1e-12);
    try testing.expect(busy.values.blur.size.? > 0 and busy.values.blur.size.? < 10);
    readability.alphas = @splat(0.95);
    const unreadable = wornWith(.{ .readability = readability }, .{});
    try testing.expectApproxEqAbs(0.95, unreadable.theme.background_alpha, 1e-12);
    try testing.expectEqual(10, unreadable.values.blur.size.?);
}

test "readability raises alpha at most to the range's max, opaque then needing no blur" {
    const look = wornWith(.{}, .{});
    try testing.expectEqual(1, look.theme.background_alpha);
    try testing.expectEqual(0, look.values.blur.size.?);
    var pinned: Mapping = .{};
    pinned.alpha.range = .{ .min = 0.7, .max = 0.9 };
    try testing.expectEqual(0.9, wornWith(.{}, pinned).theme.background_alpha);
}

test "a pinned range pins its value, and a curve bends it" {
    var mapping: Mapping = .{};
    mapping.rounding.range = .{ .min = 7, .max = 7 };
    try testing.expectEqual(7, wornWith(.{ .softness = 1 }, mapping).values.rounding.?);
    mapping = .{};
    mapping.rounding.curve = kosm.Curve.ease_out_expo.bezier;
    try testing.expect(wornWith(.{ .softness = 0.25, .blurriness = 0.25 }, mapping).values.rounding.? > 8);
}

test "a theme without traits keeps the look's values" {
    var look = default;
    look.values.blur.enabled = true;
    const worn = look.fromTraits(default.theme, .{});
    try testing.expectEqual(0, worn.values.rounding.?);
    try testing.expectEqual(null, worn.values.blur.size);
    try testing.expectEqual(true, worn.values.blur.enabled);
}

/// A loaded image of one gray, `side` pixels square.
fn testImage(comptime side: usize, lightness: f64) kosm.Image {
    const State = struct {
        var pixels: [side * side]kosm.Color = undefined;
        var planes: [side * side]f32 = undefined;
    };
    for (&State.pixels, &State.planes) |*pixel, *plane| {
        pixel.* = .{ .lightness = lightness, .chroma = 0, .hue = 0 };
        plane.* = @floatCast(lightness);
    }
    return .{ .path = "/test.png", .pixels = &State.pixels, .width = side, .lightness = &State.planes, .lightness_width = side };
}

test "a look from an image wears its colors and derives its values from its traits" {
    var look = default;
    look.values.blur.enabled = true;
    const result = try look.fromImage(testImage(32, 0.2), .{ .traits = .{ .reading = .{ .screen_width = 32 } } }, .{});
    try testing.expect(result.theme.traits != null);
    try testing.expect(result.theme.background_alpha < 1);
    try testing.expectEqual(true, result.values.blur.enabled);
    try testing.expectError(error.ImageNotLoaded, default.fromImage(.{ .path = "/a.png" }, .{}, .{}));
}
