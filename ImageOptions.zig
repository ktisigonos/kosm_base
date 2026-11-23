//! How `Look.fromImage` takes a look from an image: its colors, and how much of each shared
//! value the image calls for, within a range for each. A range of `n..n` pins that value.

const kosm = @import("kosm");

/// How colors are taken from the image.
colors: kosm.Image.Options = .{},
/// How the image is measured as a backdrop: the screen's width, the contrast text needs, the
/// thresholds of busy and soft.
measure: kosm.Image.SurfaceOptions = .{},
/// The theme's `background_alpha`: the lowest in range at which some blur in range keeps text
/// readable, or the max if none does. Default: 0.6..1.
alpha: Range = .{ .min = 0.6, .max = 1 },
/// `blur.size`: as little as keeps text readable at the alpha picked; 0 is no blur. Default:
/// 0..10.
blur_size: Range = .{ .min = 0, .max = 10 },
/// `blur.passes`, rising with `blur_size`: from somewhat blurry to acrylic glass. Default: 2..4.
blur_passes: Range = .{ .min = 2, .max = 4 },
/// `rounding`, rounder for softer images. Default: 4..16.
rounding: Range = .{ .min = 4, .max = 16 },
/// `rounding_power`, 2 being a circle, nearer a square for crisper images. Default: 2..4.
rounding_power: Range = .{ .min = 2, .max = 4 },
/// `gaps.inner`, smaller for busier images, as gaps show the wallpaper. Default: 2..6.
gaps_inner: Range = .{ .min = 2, .max = 6 },
/// `gaps.outer`, smaller for busier images. Default: 4..12.
gaps_outer: Range = .{ .min = 4, .max = 12 },
/// `border_size`, thinner for softer images. Default: 1..3.
border_size: Range = .{ .min = 1, .max = 3 },
/// `padding`, roomier for softer images. Default: 6..14.
padding: Range = .{ .min = 6, .max = 14 },
/// `shadow.range`, wider for softer images. Default: 4..20.
shadow_range: Range = .{ .min = 4, .max = 20 },
/// `shadow.render_power` (1..4, how fast the shadow fades), slower for softer images.
/// Default: 2..4.
shadow_render_power: Range = .{ .min = 2, .max = 4 },

/// The lowest and highest a value may get; whole-number values are rounded.
pub const Range = struct {
    /// The least the image may give.
    min: f64,
    /// The most the image may give.
    max: f64,

    /// The value `amount` (0..1) of the way from `min` to `max`.
    pub fn at(range: Range, amount: f64) f64 {
        return range.min + (range.max - range.min) * @max(0, @min(1, amount));
    }

    /// `at`, rounded to a whole number, never below 0.
    pub fn wholeAt(range: Range, amount: f64) u32 {
        return @intFromFloat(@max(0, @round(range.at(amount))));
    }
};
