-- extended_events: ensures non-standard events exist on the events table
local event_names = {
    "console_input",
    "aim_ack",
    "aim_fire",
    "mouse_input",
    "update_client_side",
    "style_change",
    "round_prestart",
    "enter_bombzone",
    "exit_bombzone",
    "bomb_beginplant",
    "bomb_abortplant",
    "bomb_defused",
    "bomb_planted",
}

local noop = function() end

for _, name in ipairs(event_names) do
    if not events[name] then
        events[name] = { set = noop, add = noop }
    elseif not events[name].set then
        events[name].set = noop
    end
end
