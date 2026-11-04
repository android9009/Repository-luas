---@meta
-- neverlose CS:GO API — render module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

--#region Structs

---Image object returned by render.load_image / render.load_image_rgba / render.load_image_from_file.
---@class ImgObject
---@field width number
---@field height number
---@field resolution number

---Font object returned by render.load_font.
---@class FontObject
---@field width number
---@field height number
---@field spacing number
local FontObject = {}

---Sets the new font size.
---@param size number New size of the font
---@overload fun(self: FontObject, size: vector)
function FontObject:set_size(size) end

--#endregion

--#region Functions

---@return vector
function render.screen_size() end

---Returns the camera position vector.
---@return vector
function render.camera_position() end

---Returns or sets the camera angles.
---@param angles vector? New camera angles. Optional.
---@return vector
function render.camera_angles(angles) end

---Returns the screen position vector, or nil if the world position is not visible on your screen.
---This can only be called from the render callback.
---📌 Note that there is a cleaner alternative, the `:to_screen` vector function.
---@param position vector Position in world space
---@return vector? screen_position
function render.world_to_screen(position) end

---Returns the `position`, `rotation`, and `is_out_of_fov` arguments or nil on failure.
---`position`: Screen coordinates (Returns ellipse-based position if the world position is out of FOV).
---`rotation`: Yaw axis that can be used to rotate drawing stuff.
---`is_out_of_fov`: Returns true if the world position is out of FOV.
---@param position vector Position in world space
---@param radius number Distance from the center of the screen as a percentage in the range [0.0, ∞]
---@param accurate boolean? Optional. If true then accurate calculations will be used
---@return vector? position
---@return number? rotation
---@return boolean? is_out_of_fov
function render.get_offscreen(position, radius, accurate) end

---Returns the color of the specified pixel on the screen.
---⚠️ Getting the color of the pixel is a heavy process. Do not do it inside callbacks that are
---called a lot of times per second.
---@param position vector Screen position
---@return color
function render.get_pixel(position) end

---Loads a font. Returns the `FontObject` struct or nil on failure.
---📌 Render any text via the `render.text` / `draw:text` function.
---@param name string Font that will be initialized
---@param size number Size of the font
---@param flags string? `a` for anti-aliasing, `i` for cursive text, `b` for bold text, `o` for outlined text, `d` for the drop shadow effect. Optional.
---@return FontObject
---@overload fun(name: string, size: vector, flags?: string): FontObject
function render.load_font(name, size, flags) end

---Loads an image. Returns the `ImgObject` struct or nil on failure. Supports JPG, PNG, BMP, SVG, and GIF formats.
---📌 Render any image via the `render.texture` / `:texture` function.
---@param contents string Raw image file contents
---@param size vector Size of the image
---@return ImgObject
function render.load_image(contents, size) end

---Loads an image from an RGBA buffer. Returns the `ImgObject` struct or nil on failure.
---📌 Render any image via the `render.texture` / `:texture` function.
---@param contents string RGBA buffer (HEX encoded)
---@param size vector Size of the image
---@return ImgObject
function render.load_image_rgba(contents, size) end

---Loads an image from a file. Returns the `ImgObject` struct or nil on failure.
---Supports JPG, PNG, BMP, SVG, and GIF formats.
---ℹ️ Loading images from game resources is supported.
---Example: render.load_image_from_file 'materials/panorama/images/icons/ui/warning.svg'
---📌 Render any image via the `render.texture` / `:texture` function.
---@param path string Path to the image
---@param size vector Size of the image
---@return ImgObject
function render.load_image_from_file(path, size) end

---Returns the measured size of the text.
---@param font FontObject|number Font object or 1 for Default font, 2 for Small font, or 3 for Console font
---@param flags string? Optional. `s` for DPI scaled text
---@param text string Text that will be measured
---@return vector
---@overload fun(font: FontObject|number, text: string): vector
function render.measure_text(font, flags, text) end

---Highlights the specified hitbox / hitboxes.
---@param entity entity The player whose hitbox(es) are to be highlighted.
---@param hitbox number|number[] Hitbox index (an integer between 0 and 18). A table with hitbox indices can also be used to highlight multiple hitboxes. Pass 19 to highlight every hitbox.
---@param color color The color with which you want to highlight the hitbox(es).
function render.highlight_hitbox(entity, hitbox, color) end

---Returns the DPI scale value.
---@param type number The type of DPI scale to return. 1 - Menu Scale, 2 - ESP Scale.
---@return number
function render.get_scale(type) end

--#endregion

--#region Draw functions

---@param position_a vector Start position
---@param position_b vector End position
---@param strength number Blur strength
---@param alpha number Alpha percentage in the range [0.0, 1.0]
---@param rounding number? Optional. Rounding of the blur rectangle in pixels
function render.blur(position_a, position_b, strength, alpha, rounding) end

---@param position_a vector Start position
---@param position_b vector End position
---@param color color Color of the line
---@param thickness number? Line thickness. Optional (defaults to 1).
function render.line(position_a, position_b, color, thickness) end

---@param color color Color of the polyline
---@param positions vector Screen positions
---@param ... vector Comma-separated vectors to concatenate with `positions`
function render.poly(color, positions, ...) end

---@param opacity number Opacity percentage in the range [0.0, 1.0]
---@param strength number Blur strength
---@param positions vector Screen positions
---@param ... vector Comma-separated vectors to concatenate with `positions`
function render.poly_blur(opacity, strength, positions, ...) end

---@param color color Color of the polyline
---@param positions vector Screen positions
---@param ... vector Comma-separated vectors to concatenate with `positions`
function render.poly_line(color, positions, ...) end

---@param position_a vector Start position
---@param position_b vector End position
---@param color color Color of the rectangle
---@param rounding number? Optional. Rounding of the rectangle in pixels
---@param no_clamp boolean? Optional. If true, negative sizes will be allowed
function render.rect(position_a, position_b, color, rounding, no_clamp) end

---@param position_a vector Start position
---@param position_b vector End position
---@param color color Color of the rectangle
---@param thickness number? Optional. Thickness of the rectangle in pixels
---@param rounding number? Optional. Rounding of the rectangle in pixels
---@param no_clamp boolean? Optional. If true, position_a < position_b will be allowed
function render.rect_outline(position_a, position_b, color, thickness, rounding, no_clamp) end

---@param position_a vector Start position
---@param position_b vector End position
---@param top_left color Color of the top left rectangle position
---@param top_right color Color of the top right rectangle position
---@param bottom_left color Color of the bottom left rectangle position
---@param bottom_right color Color of the bottom right rectangle position
---@param rounding number? Optional. Rounding of the gradient in pixels
function render.gradient(position_a, position_b, top_left, top_right, bottom_left, bottom_right, rounding) end

---@param position vector Screen position
---@param color color Color of the circle
---@param radius number Radius of the circle in pixels
---@param start_deg number 0 is the right side, 90 is the bottom, 180 is the left, 270 is the top
---@param pct number Percentage in the range [0.0-1.0] determining how full the circle is
function render.circle(position, color, radius, start_deg, pct) end

---@param position vector Screen position
---@param color color Color of the circle
---@param radius number Radius of the circle in pixels
---@param start_deg number 0 is the right side, 90 is the bottom, 180 is the left, 270 is the top
---@param pct number Percentage in the range [0.0-1.0] determining how full the circle is
---@param thickness number? Optional. Thickness of the outline in pixels
function render.circle_outline(position, color, radius, start_deg, pct, thickness) end

---@param position vector Screen position
---@param color_outer color Outer color of the circle
---@param color_inner color Inner color of the circle
---@param radius number Radius of the circle in pixels
---@param start_deg number 0 is the right side, 90 is the bottom, 180 is the left, 270 is the top
---@param pct number Percentage in the range [0.0-1.0] determining how full the circle is
function render.circle_gradient(position, color_outer, color_inner, radius, start_deg, pct) end

---@param position vector Screen position
---@param color color Color of the circle
---@param radius number Radius of the circle in pixels
---@param start_deg number 0 is the right side, 90 is the bottom, 180 is the left, 270 is the top
---@param pct number Percentage in the range [0.0-1.0] determining how full the circle is
---@param outline boolean? Optional. Render the circle outline
function render.circle_3d(position, color, radius, start_deg, pct, outline) end

---@param position vector Screen position
---@param color color Color of the circle
---@param radius number Radius of the circle in pixels
---@param start_deg number 0 is the right side, 90 is the bottom, 180 is the left, 270 is the top
---@param pct number Percentage in the range [0.0-1.0] determining how full the circle is
---@param thickness number? Thickness of the outline in pixels
function render.circle_3d_outline(position, color, radius, start_deg, pct, thickness) end

---@param position vector Screen position
---@param color_outer color Outer color of the circle
---@param color_inner color Inner color of the circle
---@param radius number Radius of the circle in pixels
---@param start_deg number 0 is the right side, 90 is the bottom, 180 is the left, 270 is the top
---@param pct number Percentage in the range [0.0-1.0] determining how full the circle is
function render.circle_3d_gradient(position, color_outer, color_inner, radius, start_deg, pct) end

---Draws the specified text.
---📌 Load a font via the `render.load_font` function.
---@param font FontObject|number Font object or 1 for Default font, 2 for Small font, 3 for Console font, or 4 for Bold font
---@param position vector Screen position
---@param color color Color of the text
---@param flags string? `c` for centered text, `r` for right-aligned text, `s` for DPI scaled text. nil can be specified for normal uncentered text.
---@param text any Text that will be drawn
---@param ... vector Comma-separated vectors to concatenate with `text`
function render.text(font, position, color, flags, text, ...) end

---📌 Create the texture via the `render.load_image` function.
---@param texture ImgObject Image object
---@param position vector Screen position
---@param size vector? Optional. Size of the texture
---@param color color? Optional. Color of the texture
---@param mode string? Optional. `f` for fill, `r` for repeat
---@param rounding number? Optional. Roundness of the texture
---neverlose type-detects the optional args, so `size` and `color` may be passed in either order:
---@overload fun(texture: ImgObject, position: vector, color: color, size?: vector, mode?: string, rounding?: number)
function render.texture(texture, position, size, color, mode, rounding) end

---Applies the rotation for all subsequent elements.
---@param degrees number Rotation degrees (0 - 360)
---@param center vector? Screen-space point to rotate around. Optional.
function render.push_rotation(degrees, center) end

---Discards an early set rotation.
function render.pop_rotation() end

---Applies the clip region to the given rectangle for all subsequent elements.
---@param pos_a vector Screen position of point A
---@param pos_b vector Screen position of point B
---@param intersect boolean? Optional. Allow intersections with other clip regions
function render.push_clip_rect(pos_a, pos_b, intersect) end

---Discards an early set rectangle clipping region.
function render.pop_clip_rect() end

---Draws a shadow rectangle.
---@param pos_a vector Screen position of point A
---@param pos_b vector Screen position of point B
---@param clr color The color of the shadow
---@param thickness number? The thickness of the shadow
---@param offset number? Shadow offset
---@param rounding number? The rounding of the shadow rectangle
function render.shadow(pos_a, pos_b, clr, thickness, offset, rounding) end

--#endregion
