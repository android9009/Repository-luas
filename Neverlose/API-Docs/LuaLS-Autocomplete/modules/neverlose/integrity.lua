local function creator(username_fn)
    if username_fn then
        local ok, name = pcall(username_fn)
        if ok and name then
            return name
        end
    end
    return false
end
return creator
