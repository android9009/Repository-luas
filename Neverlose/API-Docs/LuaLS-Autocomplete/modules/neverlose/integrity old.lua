local function creator(username_fn)
    if username_fn then
        pcall(username_fn)
    end
    return true
end
return creator
