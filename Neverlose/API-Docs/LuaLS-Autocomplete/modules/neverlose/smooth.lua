local smooth = {}
local namespaces = {}

smooth.auxiliary = { animation = {} }

function smooth.new(ns)
    if not namespaces[ns] then
        namespaces[ns] = {
            speed = 6,
            values = {},
        }
        smooth.auxiliary.animation[ns] = { table = { active = {} } }
    end
end

function smooth.update(ns, speed)
    if namespaces[ns] then
        namespaces[ns].speed = speed
    end
end

function smooth.lerp(from, to, speed)
    speed = speed or 6
    local dt = globals.frametime * speed
    if type(from) == "number" and type(to) == "number" then
        return from + (to - from) * math.min(dt, 1)
    elseif type(from) == "table" and type(to) == "table" then
        return color(
            from.r + (to.r - from.r) * math.min(dt, 1),
            from.g + (to.g - from.g) * math.min(dt, 1),
            from.b + (to.b - from.b) * math.min(dt, 1),
            (from.a or 255) + ((to.a or 255) - (from.a or 255)) * math.min(dt, 1)
        )
    end
    return to
end

function smooth.unclamped_lerp(from, to, speed)
    speed = speed or 6
    local dt = globals.frametime * speed
    if type(from) == "number" and type(to) == "number" then
        return from + (to - from) * dt
    end
    return to
end

function smooth.linear(ns, key, target, speed, max_speed)
    if type(target) == "boolean" then
        target = target and 1 or 0
    end
    if not namespaces[ns] then
        smooth.new(ns)
    end
    local ns_data = namespaces[ns]
    local full_key = ns .. "." .. key

    if ns_data.values[full_key] == nil then
        ns_data.values[full_key] = target
    end

    local cur = ns_data.values[full_key]
    local spd = speed or ns_data.speed
    local dt = globals.frametime * spd
    local diff = target - cur

    if max_speed then
        dt = math.min(dt, 1)
    end

    local new_val = cur + diff * math.min(dt, 1)
    ns_data.values[full_key] = new_val

    if smooth.auxiliary.animation[ns] then
        smooth.auxiliary.animation[ns].table.active[key] = new_val
    end

    return new_val
end

return smooth
