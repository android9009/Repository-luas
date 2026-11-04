local minterface = {}

local function resolve_callback(arg4, arg5)
    if type(arg4) == "function" then return arg4 end
    if type(arg5) == "function" then return arg5 end
    return nil
end

local function get_parent(groups)
    if type(groups) == "table" and groups._nl_parent then
        return groups._nl_parent
    end
    if type(groups) ~= "table" then return groups end
    local icon1 = groups[1] or ""
    local icon2 = groups[2] or ""
    local page = groups[3]
    if page then
        return ui.create(icon1, icon2, page)
    else
        return ui.create(icon1, icon2)
    end
end

local function wrap_elem(ref, callback, list_val)
    local elem = {
        ref = ref,
        _nl_parent = nil,
        get = function() return ref:get() end,
        set = function(self, v) ref:set(v) end,
        set_callback = function(self, cb) ref:set_callback(cb) end,
        visibility = function(self, v)
            if v ~= nil then ref:visibility(v) else ref:visibility() end
        end,
        get_override = function() return ref:get_override() end,
        override = function(self, v) ref:override(v) end,
        list = function() return list_val or {} end,
        [0] = {},
    }
    if type(callback) == "function" then
        local child_group = ref:create()
        elem._nl_parent = child_group
        local ok, children = pcall(callback, elem)
        if ok and type(children) == "table" then
            elem[0] = children
        end
    else
        elem._nl_parent = ref
    end
    return elem
end

function minterface.Button(groups, label, arg4, arg5)
    local callback = resolve_callback(arg4, arg5)
    local parent = get_parent(groups)
    local ref = parent:button(label, callback)
    return wrap_elem(ref, nil)
end

function minterface.Switch(groups, label, default, arg4, arg5)
    local callback = resolve_callback(arg4, arg5)
    local parent = get_parent(groups)
    local ref = parent:switch(label)
    if type(default) == "table" then
        if default[1] then ref:set(true) end
    elseif type(default) == "boolean" and default then
        ref:set(true)
    end
    return wrap_elem(ref, callback)
end

function minterface.Combo(groups, label, options, arg4, arg5)
    local callback = resolve_callback(arg4, arg5)
    local parent = get_parent(groups)
    local opts = {}
    if type(options) == "table" then
        if type(options[1]) == "table" then
            opts = options[1]
        else
            opts = options
        end
    end
    local ref = parent:combo(label, opts)
    return wrap_elem(ref, callback, opts)
end

function minterface.MultiCombo(groups, label, options, arg4, arg5)
    local callback = resolve_callback(arg4, arg5)
    local parent = get_parent(groups)
    local opts = {}
    if type(options) == "table" then
        if type(options[1]) == "table" then
            opts = options[1]
        else
            opts = options
        end
    end
    local ref = parent:selectable(label, opts)
    return wrap_elem(ref, callback, opts)
end

function minterface.Slider(groups, label, params, arg4, arg5)
    local callback = resolve_callback(arg4, arg5)
    local parent = get_parent(groups)
    local p_min, p_max, p_default, p_step = 0, 100, 0, 1
    if type(params) == "table" then
        p_default = params[1] or 0
        p_min = params[2] or 0
        p_max = params[3] or 100
        p_step = params[4] or 1
    end
    local ref = parent:slider(label, p_min, p_max, p_default, p_step)
    return wrap_elem(ref, callback)
end

function minterface.Text(groups, label, arg4, arg5)
    local parent = get_parent(groups)
    local ref = parent:button(label)
    return wrap_elem(ref, nil)
end

function minterface.ColorEdit(groups, label, params, arg4, arg5)
    local parent = get_parent(groups)
    local default_color = nil
    if type(params) == "table" then
        default_color = params[1]
    end
    local ref = parent:color_picker(label, default_color)
    return wrap_elem(ref, nil)
end

return minterface
