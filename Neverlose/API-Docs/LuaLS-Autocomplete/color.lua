---@meta
-- neverlose CS:GO API — color module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---A color object with r, g, b, and a channels in the range [0, 255].
---Fields can be read and written directly (e.g. `col.r = 255`).
---@class color
---@field r number R color range [0, 255]
---@field g number G color range [0, 255]
---@field b number B color range [0, 255]
---@field a number A color range [0, 255]
local color_object = {}

---Creates and returns a copy of the color object.
---@return color
function color_object:clone() end

---Overwrites the color's ranges. Returns itself.
---
---Available overloads (RGBA):
---  color() -> 255, 255, 255, 255
---  color(200) -> 200, 200, 200, 255
---  color(255, 160) -> 255, 255, 255, 160
---  color(255, 195, 25) -> 255, 195, 25, 255
---  color(255, 195, 25, 200) -> 255, 195, 25, 200
---@param r number New R color range
---@param g number New G color range
---@param b number New B color range
---@param a number New A color range
---@return color
---@overload fun(self: color, value: string): color
function color_object:init(r, g, b, a) end

---Overwrites the color's ranges using the fraction values. Returns itself.
---@param r number New R color range as a percentage in the range [0.0, 1.0]
---@param g number New G color range as a percentage in the range [0.0, 1.0]
---@param b number New B color range as a percentage in the range [0.0, 1.0]
---@param a number New A color range as a percentage in the range [0.0, 1.0]
---@return color
function color_object:as_fraction(r, g, b, a) end

---Overwrites the color's ranges converting the int32 value to RGBA values. Returns itself.
---@param value number int32 color value
---@return color
function color_object:as_int32(value) end

---Overwrites the color's ranges converting the HSV to RGBA values. Returns itself.
---@param h number Hue color range [0.0, 1.0]
---@param s number Saturation color range [0.0, 1.0]
---@param v number Value color range [0.0, 1.0]
---@param a number Alpha color range [0.0, 1.0]
---@return color
function color_object:as_hsv(h, s, v, a) end

---Overwrites the color's ranges converting the HSL to RGBA values. Returns itself.
---@param h number Hue color range [0.0, 1.0]
---@param s number Saturation color range [0.0, 1.0]
---@param l number Lightness color range [0.0, 1.0]
---@param a number Alpha color range [0.0, 1.0]
---@return color
function color_object:as_hsl(h, s, l, a) end

---Returns the r, g, b, and a ranges of the color as a percentage in the range of [0.0, 1.0].
---@return number r
---@return number g
---@return number b
---@return number a
function color_object:to_fraction() end

---Returns the HEX string representing the color.
---@return string
function color_object:to_hex() end

---Returns the int32 value representing the color.
---@return number
function color_object:to_int32() end

---Returns the HSV representation of the color.
---@return number h
---@return number s
---@return number v
function color_object:to_hsv() end

---Returns the HSL representation of the color.
---@return number h
---@return number s
---@return number l
function color_object:to_hsl() end

---Returns the linearly interpolated color between two colors by the specified weight.
---@param other color The color to interpolate to
---@param weight number A value between 0 and 1 that indicates the weight of other
---@return color
function color_object:lerp(other, weight) end

---Returns the grayscaled color.
---@param weight number? Optional. A value between 0 and 1 that indicates the weight of grayscale
---@return color
function color_object:grayscale(weight) end

---Returns the current color with an overridden Alpha color range.
---@param alpha number Alpha color range [0, 255]
---@return color
function color_object:alpha_modulate(alpha) end

---Returns the r, g, b, and a values of the color.
---Note that these fields can be accessed by indexing r, g, b, and a.
---@return number r
---@return number g
---@return number b
---@return number a
function color_object:unpack() end

---Creates a color object with a flexible constructor.
---
---Available overloads (RGBA):
---  color() -> 255, 255, 255, 255
---  color(200) -> 200, 200, 200, 255
---  color(255, 160) -> 255, 255, 255, 160
---  color(255, 195, 25) -> 255, 195, 25, 255
---  color(255, 195, 25, 200) -> 255, 195, 25, 200
---
---Available overloads (HEX -> RGBA):
---  color 'C8' -> 200, 200, 200, 255
---  color 'FFA0' -> 255, 255, 255, 160
---  color 'FFC319' -> 255, 195, 25, 255
---  color 'AABBCCDD' -> 170, 187, 204, 221
---@param r number? New R color range
---@param g number? New G color range
---@param b number? New B color range
---@param a number? New A color range
---@return color
---@overload fun(value: string): color
function color(r, g, b, a) end
