-- if you 1 someone (headshot), report the stats behind that beautiful 1

local startWords = {
    'Owned',
    '1\'d',
    '1 tapped',
    'Destroyed',
    'Shit on',
    'Ripped head of',
    'Fucked',
    'Resolved',
    "Humiliated",
    "Fucked up",
    "Headshot",
    "Idealticked",
    "Singular'd",
    "Domed",
    "Executed",
    "Eliminated",
    "Annihilated",
    "Neutralized",
    "Ended",
    "Pwned",
    "Smoked",
    "Stomped",
    "Wasted",
    "Lit Up",
    "Capped",
    "Dropped",
    "Obliterated",
    "Demolished",
    "Merked",
    "Murked",
    "Iced",
    "Wrecked",
    "Crushed",
    "Slimed",
    "Slumped",
    "Folded"
}

-- function to check the remaining hp of the player shot
events.aim_ack:set(function(shot)
    -- get enemy pointer
    local target = shot.target
    local get_target_entity = entity.get(target)
    if not get_target_entity then return end

    -- get enemy details
    local get_enemy_health = get_target_entity.m_iHealth
    if not target:get_name() or not get_enemy_health then return end
    local get_enemy_name = target:get_name()

    -- reformat shot result
    local result = (shot.state == nil) and "Hit" or shot.state

    -- if miss or baim, just end
    -- for reference, list of hitgroups: 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', 'generic', 'gear'
    if (shot.hitgroup ~= 1 or not (shot.damage >= 0)) then return end

    print(string.format("Fired at: %s | HC: %i | ED: %i | AD: %i | Result: %s | BT: %i | Mismatched: %s",
    get_enemy_name, shot.hitchance, shot.wanted_damage, shot.damage, result, shot.backtrack, shot.wanted_hitgroup ~= shot.hitgroup))

    -- reformat the enemy name if it contains non-ascii characters (for example, handling retarded Russians or the Chinese)
    -- if ((string.match(get_enemy_name, "[^%z\1-\127]")) and true or false) then
    --     get_enemy_name = string.gsub(get_enemy_name, "[^%z\1-\127]", "")
    --     -- if formatted name or original name is empty string, replace with undefined
    --     get_enemy_name = (get_enemy_name == "" and get_enemy_name == nil) and "undefined" or get_enemy_name
    -- end

    -- if we hit the head with our shot
    if (shot.hitgroup == 1) then
        print("Remaining HP: " .. get_enemy_health)

        -- check if we killed the enemy
        if (get_enemy_health <= 0) then
            -- we killed them
            utils.console_exec("say " .. startWords[utils.random_int(1, #startWords)] .. string.format(": %s | HC: %i | ED: %i | AD: %i | Result: %s | BT: %i | Mismatched: %s",
                get_enemy_name, shot.hitchance, shot.wanted_damage, shot.damage, result, shot.backtrack, shot.wanted_hitgroup ~= shot.hitgroup))
        else
            -- we didn't kill them, but we dinked them in the head
            utils.console_exec("say " .. string.format("Dinked: %s | HC: %i | ED: %i | AD: %i | Result: %s | BT: %i | Mismatched: %s",
                get_enemy_name, shot.hitchance, shot.wanted_damage, shot.damage, result, shot.backtrack, shot.wanted_hitgroup ~= shot.hitgroup))
        end
    end

end)
