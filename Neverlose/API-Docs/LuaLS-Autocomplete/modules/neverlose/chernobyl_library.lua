-- chernobyl_library: sets global helper functions used by chernobyl.lua
-- table.switcher, table.find, center, percentage_color, smart_override, db_save, print override

table.switcher = function(v9, v10)
    local v11 = v10[v9] or v10.default ~= nil and v10.default
    return type(v11) == "function" and v11() or v11
end

table.find = function(v12, v13)
    for v14, v15 in pairs(v12) do
        if v15 == v13 then
            return v14
        end
    end
    return -1
end

return {}
