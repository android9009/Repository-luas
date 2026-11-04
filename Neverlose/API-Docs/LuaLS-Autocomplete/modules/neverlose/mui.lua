local mui = {}
local all_widgets = {}
local _type = type
local _pcall = pcall
local _pairs = pairs
local _ipairs = ipairs
local _rawget = rawget
local _setmetatable = setmetatable

local function wrap(nl_element, wtype, callback)
    local children = {}
    local widget = {
        _element = nl_element,
        _type = wtype,
        _label = "",
        _value = nil,
        _children = children,
    }

    if nl_element and nl_element.name then
        widget._label = nl_element:name() or ""
    end
    widget.default = widget._label

    function widget:get(item_name)
        if not nl_element then
            if item_name then return false end
            return (wtype == "switch" or wtype == "multi_combo") and false or nil
        end
        local ok, val = _pcall(function() return nl_element:get() end)
        if not ok then
            if item_name then return false end
            return (wtype == "switch" or wtype == "multi_combo") and false or nil
        end
        if item_name then
            if _type(val) == "table" then
                for _, v in _pairs(val) do
                    if v == item_name then return true end
                end
            end
            return false
        end
        if val == nil and (wtype == "switch" or wtype == "multi_combo") then
            return false
        end
        return val
    end

    function widget:set(val)
        if nl_element and nl_element.set then
            nl_element:set(val)
        end
    end

    function widget:set_callback(fn, immediate)
        if nl_element and nl_element.set_callback then
            nl_element:set_callback(function()
                _pcall(fn, widget)
            end, immediate == true)
        end
    end

    function widget:visibility(visible)
        if nl_element and nl_element.visibility then
            nl_element:visibility(visible)
        end
    end

    function widget:name(new_name)
        if nl_element and nl_element.name then
            if new_name then nl_element:name(new_name) end
            return nl_element:name() or ""
        end
        return ""
    end

    function widget:tooltip(t) end
    function widget:update(items) end
    function widget:list() return {} end
    function widget:depend(...) end

    if callback and wtype ~= "button" and nl_element then
        local ok, result = _pcall(callback, widget)
        if ok and _type(result) == "table" then
            for k, v in _pairs(result) do
                children[k] = v
            end
        end
    end

    widget["gear"] = children

    _setmetatable(widget, {
        __index = function(t, k)
            if k == 0 then return children end
            if nl_element then
                local ok, v = _pcall(function() return nl_element[k] end)
                if ok and v ~= nil then
                    if _type(v) == "function" then
                        return function(_, ...)
                            return v(nl_element, ...)
                        end
                    end
                    return v
                end
            end
            return _rawget(t, k)
        end
    })

    all_widgets[#all_widgets + 1] = widget
    return widget
end

function mui.switch(parent, label, default, callback)
    if not parent or not parent.switch then
        return wrap(nil, "switch", callback)
    end
    local el
    if default ~= nil then
        el = parent:switch(label, default)
    else
        el = parent:switch(label, false)
    end
    return wrap(el, "switch", callback)
end

function mui.slider(parent, label, default, min, max, step, tooltip, format_fn)
    if not parent or not parent.slider then
        return wrap(nil, "slider")
    end
    local el = parent:slider(label, min or 0, max or 100, default or 0, step or nil)
    if format_fn and el and el.set_format then
        el:set_format(format_fn)
    end
    local w = wrap(el, "slider")
    w._min = min or 0
    w._max = max or 100
    w._step = step or 1
    w._format = format_fn
    return w
end

function mui.combo(parent, label, items, callback)
    if not parent or not parent.combo then
        return wrap(nil, "combo", callback)
    end
    local el = parent:combo(label, items)
    return wrap(el, "combo", callback)
end

function mui.multi_combo(parent, label, items, callback)
    if not parent or not parent.selectable then
        return wrap(nil, "multi_combo", callback)
    end
    local el = parent:selectable(label, items)
    return wrap(el, "multi_combo", callback)
end

function mui.button(parent, label, style, callback)
    if not parent or not parent.button then
        local w = wrap(nil, "button")
        if callback then w._on_click = callback end
        return w
    end
    local el = parent:button(label, function()
        if callback then _pcall(callback, el) end
    end, style)
    return wrap(el, "button")
end

function mui.color_edit(parent, label, default)
    if parent and parent.color then
        local el = parent:color(label)
        if el and default and el.set then el:set(default) end
        return wrap(el, "color_edit")
    end
    local w = wrap(nil, "color_edit")
    w._value = default
    function w:get() return self._value end
    function w:set(v) self._value = v end
    return w
end

function mui.hotkey(parent, label)
    if not parent or not parent.hotkey then
        return wrap(nil, "hotkey")
    end
    return wrap(parent:hotkey(label), "hotkey")
end

function mui.text_box(parent, label, default)
    if not parent or not parent.input then
        local w = wrap(nil, "text_box")
        w._value = default or ""
        return w
    end
    local el = parent:input(label)
    if el and default and el.set then el:set(default) end
    return wrap(el, "text_box")
end

function mui.table(parent, label, items)
    if not parent or not parent.table then
        return wrap(nil, "table")
    end
    return wrap(parent:table(label, items), "table")
end

function mui.multi_table(parent, label, items)
    return wrap(nil, "multi_table")
end

function mui.text(parent, label)
    if parent and parent.text then
        return wrap(parent:text(label), "text")
    end
    return wrap(nil, "text")
end

function mui.header(label)
    return label
end

function mui.sidebar(text, icon) end

mui.configs = {}

function mui.configs.save(ui_tree, sections)
    local data = {}
    for _, w in _ipairs(all_widgets) do
        if w._value ~= nil then
            data[w._label] = w._value
        end
    end
    return data
end

function mui.configs.load(ui_tree, data)
    if not data then return end
    for _, w in _ipairs(all_widgets) do
        if data[w._label] ~= nil then
            w._value = data[w._label]
        end
    end
end

return mui
