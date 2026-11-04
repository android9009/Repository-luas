local function creator(name)
    return {
        createmove = function(cmd) end,
        get_positions = function() return {} end,
    }
end
return creator
