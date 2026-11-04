local function creator(key)
    return {
        readfile = function(path) return "" end,
        writefile = function(path, data) end,
        file_exists = function(path) return false end,
    }
end
return creator
