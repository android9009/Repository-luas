local function creator(key)
    return {
        planted = false,
        defused = false,
        site = "",
        time_to_explode = 0,
        get_origin = function() return vector(0, 0, 0) end,
    }
end
return creator
