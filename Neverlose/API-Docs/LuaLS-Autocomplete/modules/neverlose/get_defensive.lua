local max_tickbase = 0

local function get_defensive(...)
    local args = {...}
    local argc = #args

    local ok, result = pcall(function()
        local lp = entity.get_local_player()
        if not lp then
            return nil
        end

        local alive_ok, alive = pcall(function() return lp:is_alive() end)
        if not alive_ok or not alive then
            return nil
        end

        local tick_ok, tickbase = pcall(function() return lp.m_nTickBase end)
        if not tick_ok or not tickbase then
            return nil
        end

        if math.abs(tickbase - max_tickbase) > 64 then
            max_tickbase = 0
        end

        local defensive_ticks = 0

        if tickbase > max_tickbase then
            max_tickbase = tickbase
        elseif max_tickbase > tickbase then
            defensive_ticks = math.min(14, math.max(0, max_tickbase - tickbase - 1))
        end

        return defensive_ticks
    end)

    if not ok or result == nil then
        if argc == 0 then
            return false
        end
        return 0
    end

    if argc == 0 then
        return result > 0
    end

    if argc == 1 then
        local arg = args[1]
        if type(arg) == "string" then
            if arg == "safe" then
                return result > 2
            end
            return result > 0
        end
        return result
    end

    return result
end

return get_defensive
