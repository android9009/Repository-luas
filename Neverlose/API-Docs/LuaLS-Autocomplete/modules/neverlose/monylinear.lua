local monylinear = {}
monylinear.__index = monylinear

local function get_hex(c)
    if type(c) == "table" then
        return string.format("%02x%02x%02x%02x", c.a or 255, c.r or 255, c.g or 255, c.b or 255)
    end
    return "FFFFFFFF"
end

function monylinear:Static(name, colors)
    local c = colors and colors[1]
    if c then
        return "\a" .. get_hex(c) .. name
    end
    return name
end

function monylinear:Animate(text, colors, speed, ...)
    local c = colors and colors[1]
    if c then
        return "\a" .. get_hex(c) .. text
    end
    return text
end

return monylinear
