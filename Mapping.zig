//! How `Look.fromTraits` turns a source's traits into the look's shared values: each value a
//! weighted mix of traits, through a curve, into a range. A range of `n..n` pins that value.

const kosm = @import("kosm");

/// The theme's `background_alpha`, before readability: lower for calm, flat or blurry pictures.
/// It is a floor's target only: alpha rises to what keeps text readable at the strongest blur
/// in range, up to the range's max. Default: 0.6..1, from detail, flatness and blurriness.
alpha: Rule = .{ .range = .{ .min = 0.6, .max = 1 }, .from = .{
    .detail = .{ .weight = 2, .low = 0, .high = 1 },
    .flatness = falling,
    .blurriness = falling,
} },
/// `blur.size`: the least in range at which text reads at the alpha picked; 0 is no blur.
/// Default: 0..10.
blur_size: Range = .{ .min = 0, .max = 10 },
/// `blur.passes`, rising with `blur_size`: from somewhat blurry to acrylic glass. Default: 2..4.
blur_passes: Range = .{ .min = 2, .max = 4 },
/// `rounding`, rounder for softer and blurrier pictures, square for crisp ones. Default: 0..16.
rounding: Rule = .{ .range = .{ .min = 0, .max = 16 }, .from = .{ .softness = rising, .blurriness = rising } },
/// `rounding_power`, 2 being a circle, nearer a square for crisper pictures. Default: 2..4.
rounding_power: Rule = .{ .range = .{ .min = 2, .max = 4 }, .from = .{ .softness = falling } },
/// `gaps.inner`, smaller for busier pictures, as gaps show the wallpaper. Default: 2..6.
gaps_inner: Rule = .{ .range = .{ .min = 2, .max = 6 }, .from = .{ .detail = falling } },
/// `gaps.outer`, smaller for busier pictures. Default: 4..12.
gaps_outer: Rule = .{ .range = .{ .min = 4, .max = 12 }, .from = .{ .detail = falling } },
/// `border_size`, thinner for softer pictures. Default: 1..3.
border_size: Rule = .{ .range = .{ .min = 1, .max = 3 }, .from = .{ .softness = falling } },
/// `padding`, roomier for softer pictures. Default: 6..14.
padding: Rule = .{ .range = .{ .min = 6, .max = 14 }, .from = .{ .softness = rising } },
/// `shadow.range`, wider for softer pictures. Default: 4..20.
shadow_range: Rule = .{ .range = .{ .min = 4, .max = 20 }, .from = .{ .softness = rising } },
/// `shadow.render_power` (1..4, how fast the shadow fades), slower for softer pictures.
/// Default: 2..4.
shadow_render_power: Rule = .{ .range = .{ .min = 2, .max = 4 }, .from = .{ .softness = falling } },
/// `glow.range`, wider the more the picture glows; 0 turns the glow off. Default: 0..15.
glow_range: Rule = .{ .range = .{ .min = 0, .max = 15 }, .from = .{ .glow = rising } },
/// `glow.render_power` (1..4, how fast the glow fades), slower the more the picture glows.
/// Default: 2..4.
glow_render_power: Rule = .{ .range = .{ .min = 2, .max = 4 }, .from = .{ .glow = falling } },
/// Whether `glow.active` becomes the color of what glows in the picture, the unfocused glow
/// following it. Default: true.
glow_color: bool = true,

/// A trait counting toward its value as it grows.
pub const rising: Contributor = .{ .weight = 1, .low = 0, .high = 1 };
/// A trait counting toward its value as it shrinks.
pub const falling: Contributor = .{ .weight = 1, .low = 1, .high = 0 };

/// One trait's part in a value: its weight against the others, and the trait's values (0..1)
/// its part rises between, `low` above `high` for one falling as the trait grows.
pub const Contributor = kosm.Image.Contributor;

/// One derived value: the mix of `from`, bent by `curve`, placed within `range`.
pub const Rule = struct {
    /// The lowest and highest the value may get.
    range: Range,
    /// Bends the mix (time, 0..1) into the share of the range (progress); a progress beyond
    /// 0..1 is clamped to the range. Default: straight.
    curve: kosm.Curve.Bezier = kosm.Curve.linear.bezier,
    /// The traits the value is mixed from.
    from: Mix,

    /// The value the traits give.
    pub fn at(rule: Rule, traits: kosm.Traits) f64 {
        return rule.range.at(rule.curve.at(rule.from.amount(traits)));
    }

    /// `at`, rounded to a whole number, never below 0.
    pub fn wholeAt(rule: Rule, traits: kosm.Traits) u32 {
        return Range.whole(rule.at(traits));
    }
};

/// The traits a value is mixed from, by weight; null leaves a trait out, as does weight 0.
pub const Mix = struct {
    /// `kosm.Traits.detail`: how busy.
    detail: ?Contributor = null,
    /// `kosm.Traits.softness`: how soft its edges are.
    softness: ?Contributor = null,
    /// `kosm.Traits.glow`: how much it glows.
    glow: ?Contributor = null,
    /// `kosm.Traits.flatness`: how much of it is a few solid colors.
    flatness: ?Contributor = null,
    /// `kosm.Traits.blurriness`: how out of focus.
    blurriness: ?Contributor = null,
    /// `kosm.Traits.lightness`: how light on average.
    lightness: ?Contributor = null,
    /// `kosm.Traits.contrast`: how far apart its darkest and lightest parts are.
    contrast: ?Contributor = null,
    /// `kosm.Traits.colorfulness`: how colorful.
    colorfulness: ?Contributor = null,
    /// `kosm.Traits.warmth`: 0 cold, 1 warm.
    warmth: ?Contributor = null,

    /// The weighted average of the parts the traits give, 0..1; 0 when no trait counts.
    pub fn amount(mix: Mix, traits: kosm.Traits) f64 {
        var sum: f64 = 0;
        var total: f64 = 0;
        inline for (@typeInfo(Mix).@"struct".field_names) |name| {
            if (@field(mix, name)) |contributor| {
                const weight = @max(0, contributor.weight);
                sum += weight * contributor.amount(@field(traits, name));
                total += weight;
            }
        }
        return if (total == 0) 0 else sum / total;
    }
};

/// The lowest and highest a value may get; whole-number values are rounded.
pub const Range = struct {
    /// The least the traits may give.
    min: f64,
    /// The most the traits may give.
    max: f64,

    /// The value `amount` (0..1, clamped) of the way from `min` to `max`.
    pub fn at(range: Range, amount: f64) f64 {
        return range.min + (range.max - range.min) * @max(0, @min(1, amount));
    }

    /// `at`, rounded to a whole number, never below 0.
    pub fn wholeAt(range: Range, amount: f64) u32 {
        return whole(range.at(amount));
    }

    fn whole(value: f64) u32 {
        return @intFromFloat(@max(0, @round(value)));
    }
};

const std = @import("std");
const testing = std.testing;

test "a mix averages its traits by weight, falling ones turned around, and is 0 with none" {
    const mix: Mix = .{ .softness = rising, .detail = .{ .weight = 3, .low = 1, .high = 0 } };
    try testing.expectApproxEqAbs((0.8 + 3 * 0.75) / 4.0, mix.amount(.{ .softness = 0.8, .detail = 0.25 }), 1e-12);
    try testing.expectEqual(0, (Mix{}).amount(.{ .softness = 1 }));
    try testing.expectEqual(0, (Mix{ .softness = .{ .weight = 0, .low = 0, .high = 1 } }).amount(.{ .softness = 1 }));
}

test "a rule bends its mix through its curve and stays within its range" {
    var rule: Rule = .{ .range = .{ .min = 0, .max = 10 }, .from = .{ .softness = rising } };
    try testing.expectApproxEqAbs(5, rule.at(.{ .softness = 0.5 }), 1e-12);
    rule.curve = kosm.Curve.ease_out_expo.bezier;
    try testing.expect(rule.at(.{ .softness = 0.5 }) > 9);
    rule.curve = kosm.Curve.ease_out_back.bezier;
    try testing.expectEqual(10, rule.at(.{ .softness = 0.7 }));
    try testing.expectEqual(10, rule.wholeAt(.{ .softness = 0.7 }));
}
