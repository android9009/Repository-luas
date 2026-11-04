---@meta
-- neverlose CS:GO API — entity module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

--=============================================================================
-- entity MODULE (global namespace table)
--=============================================================================

entity = {}

---Returns a pointer to the specified entity.
---@param idx number Index of the entity
---@param by_userid boolean? If `true` then `idx` will be perceived as a userid. Optional.
---@return entity
function entity.get(idx, by_userid) end

---Returns a pointer to the local player.
---@return entity
function entity.get_local_player() end

---If the callback is nil, it returns the table of pointers to player entities.
---Otherwise the callback will be called. Access the player pointer using the
---arguments of the specified callback.
---@param enemies_only boolean? If `true` then only enemies will be included. Optional.
---@param include_dormant boolean? If `true` then dormant players will be included. Optional.
---@param callback fun(ent: entity)? A callback with an entity pointer as the argument. Optional.
---@return entity[] players
function entity.get_players(enemies_only, include_dormant, callback) end

---If the callback is nil, it returns the table of pointers to entities.
---Otherwise the callback will be called. Access the entity pointer using the
---arguments of the specified callback.
---@param class number|string|nil Either a name or an ID of the needed class. Pass `nil` to get every entity. Optional.
---@param include_dormant boolean? If `true` then dormant players will be included. Optional.
---@param callback fun(ent: entity)? A callback with an entity pointer as the argument. Optional.
---@return entity[] entities
function entity.get_entities(class, include_dormant, callback) end

---Returns a pointer to the current threat.
---@param hittable boolean? If `true` then returns a pointer to the player that can hit you. Optional.
---@return entity
function entity.get_threat(hittable) end

---Returns the pointer to the CCSGameRulesProxy instance, or nil if none exists.
---@return entity?
function entity.get_game_rules() end

---Returns the pointer to the CCSPlayerResource instance, or nil if none exists.
---@return entity?
function entity.get_player_resource() end

--=============================================================================
-- entity OBJECT (pointer returned by the functions above)
--=============================================================================

-- Netprops
-- --------
-- An entity pointer supports networked-property access via indexing, in
-- addition to the methods declared below.
--
-- Getting the FFI pointer:
--     ent[0]                  -- returns the ffi pointer (userdata) to the entity
--
-- Getting netprop values:
--     ent.prop_name           -- value of the networked property `prop_name`
--     ent.prop_name[index]    -- value at array index if `prop_name` is an array
--     ent["prop_name"]        -- value of the networked property `prop_name`
--
-- Setting netprop values:
--     ent.prop_name = value
--     ent.prop_name[index] = value
--     ent["prop_name"] = value
--
-- Example (createmove callback):
--     local localplayer = entity.get_local_player()
--     local health  = localplayer.m_iHealth              -- example 1
--     local pitch   = localplayer.m_flPoseParameter[12]  -- example 2 [array netprop]
--     local stamina = localplayer['m_flStamina']         -- example 3
--
-- Example (setting):
--     for _, player in ipairs(entity.get_players(true)) do
--         player.m_bSpotted = true                       -- example 1
--         player.m_flPoseParameter[12] = 0.5             -- example 2 [array netprop]
--         player['m_nSkin'] = 2                           -- example 3
--     end

---@class entity
---FFI pointer (userdata) to the entity. Accessed via `ent[0]`.
---@field [0]? userdata
---Networked property (netprop) access by name, e.g. `ent.m_iHealth`,
---`ent['m_flStamina']`, or array netprops `ent.m_flPoseParameter[12]`.
---Returns/accepts any value; assignable (`ent.m_bSpotted = true`).
---@field [string] any
local entity_obj = {}

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

---Returns `true` if the entity is a player entity.
---@return boolean
function entity_obj:is_player() end

---Returns `true` if the entity is a weapon entity.
---@return boolean
function entity_obj:is_weapon() end

---Returns `true` if the entity is dormant.
---@return boolean
function entity_obj:is_dormant() end

---Returns `true` if the entity is a bot.
---@return boolean
function entity_obj:is_bot() end

---Returns `true` if the entity is alive.
---@return boolean
function entity_obj:is_alive() end

---Returns `true` if the entity is an enemy.
---@return boolean
function entity_obj:is_enemy() end

---Returns `true` if the entity is visible.
---@return boolean
function entity_obj:is_visible() end

---If the `to_entity` is nil, the local player is checked.
---Returns `true` if the entity is completely occluded for the current entity.
---@param to_entity entity? Optional. The entity that will be checked for occlusion.
---@return boolean
function entity_obj:is_occluded(to_entity) end

---Returns the index of the entity.
---@return number
function entity_obj:get_index() end

---Returns the player name, weapon name or class name if the entity is neither of those.
---@return string
function entity_obj:get_name() end

---Returns the position vector of the entity.
---@return vector
function entity_obj:get_origin() end

---Returns the absolute angles of the entity.
---@return vector
function entity_obj:get_angles() end

---Returns a table containing `current` and `old` simulation time values.
---@return table
function entity_obj:get_simulation_time() end

---Returns the name of the entity's class.
---@return string
function entity_obj:get_classname() end

---Returns the ID of the entity's class.
---@return number
function entity_obj:get_classid() end

---Returns a table containing all materials used by the entity.
---@return table
function entity_obj:get_materials() end

---Returns the model name of the entity.
---@return string
function entity_obj:get_model_name() end

--------------------------------------------------------------------------------
-- Players
--------------------------------------------------------------------------------

---Returns the network state of the player.
---0: The entity is not dormant.
---1: The entity is dormant but the cheat has 100% info where the player is.
---2: The entity is dormant (updated by Shared ESP).
---3: The entity is dormant (updated by Sounds).
---4: The entity is dormant (not updated).
---5: The entity is dormant (data is unavailable or too old).
---@return number
function entity_obj:get_network_state() end

---Returns a table containing `pos1`, `pos2`, and `alpha` values.
---@return table
function entity_obj:get_bbox() end

---Returns a table containing information from the `player_info_t` structure of the entity.
---Table values: `is_hltv`, `is_fake_player`, `steamid`, `steamid64`, `userid`, and `files_downloaded`.
---@return table
function entity_obj:get_player_info() end

---Returns a pointer to the player's weapon entity.
---If `all_weapons` is `true`, returns a table containing pointers to every weapon
---entity the player is currently carrying.
---@param all_weapons boolean? If `true` then all weapons will be included. Optional.
---@return entity|entity[]
function entity_obj:get_player_weapon(all_weapons) end

---Returns a table containing information about the animation state of the player.
---@return table
function entity_obj:get_anim_state() end

---Returns a table containing information about the specified animation layer.
---Pass `nil` to get every animation layer.
---@param idx number? Index of the animation layer. Optional.
---@return table
function entity_obj:get_anim_overlay(idx) end

---Returns the eye position of the player.
---@return vector
function entity_obj:get_eye_position() end

---Returns the position of the specified bone.
---@param idx number Index of the bone
---@return vector
function entity_obj:get_bone_position(idx) end

---Returns the position of the specified hitbox.
---@param idx number Index of the hitbox
---@return vector
function entity_obj:get_hitbox_position(idx) end

---Returns a pointer to the Steam avatar image object of the specified entity.
---@return ImgObject
function entity_obj:get_steam_avatar() end

---Returns the Steam ID of the player.
---@return string
function entity_obj:get_xuid() end

---Returns the pointer to the CCSPlayerResource instance attached to the player, or nil if none exists.
---@return entity?
function entity_obj:get_resource() end

---Returns a table of pointers to the players that are currently spectating the specified player.
---@return entity[]
function entity_obj:get_spectators() end

---Sets an icon in the scoreboard next to the specified player's avatar.
---The icon will be removed if no icon was provided.
---@param icon string? Optional. URL to the icon or a panorama path.
function entity_obj:set_icon(icon) end

---Allows you to simulate players' movement by optionally providing an origin,
---velocity, and flags. Returns an instance of the `sim_ctx` class containing
---details and tools for the movement simulation.
---@param origin vector? Specifies the origin from which the movement should be simulated. If not provided, it uses the player's current origin. Optional.
---@param velocity vector? Specifies the velocity vector for the simulated movement. If not provided, the player's current velocity is used. Optional.
---@param flags number? Specifies the m_fFlags 32-bit mask for prediction. If not provided, the player's current `m_fFlags` value is used. Optional.
---@return sim_ctx
function entity_obj:simulate_movement(origin, velocity, flags) end

--------------------------------------------------------------------------------
-- Weapons
-- Access functions listed below via the :get_player_weapon function.
--------------------------------------------------------------------------------

---Returns the index of the weapon.
---@return number
function entity_obj:get_weapon_index() end

---Returns the icon of the weapon.
---@return ImgObject
function entity_obj:get_weapon_icon() end

---Returns a pointer to the `CCSWeaponInfo` struct of the weapon.
---@return userdata
function entity_obj:get_weapon_info() end

---Returns a pointer to the weapon owner's entity.
---@return entity
function entity_obj:get_weapon_owner() end

---Returns the weapon reload percentage (0.0-1.0), -1 if not reloading.
---@return number
function entity_obj:get_weapon_reload() end

---Returns the maximum speed the player can move with the weapon.
---@return number
function entity_obj:get_max_speed() end

---Returns the spread of the weapon in radians.
---@return number
function entity_obj:get_spread() end

---Returns the inaccuracy of the weapon in radians.
---@return number
function entity_obj:get_inaccuracy() end

--=============================================================================
-- sim_ctx OBJECT (Simulation Context)
--=============================================================================

---@class sim_ctx
---This class encapsulates the context and results of a movement simulation
---initiated by `:simulate_movement`.
---@field origin vector Position of the player after simulation.
---@field velocity vector Velocity of the player after simulation.
---@field view_offset number Z axis view offset. Used to calculate the eye position.
---@field duck_amount number `m_flDuckAmount` value of the player after simulation.
---@field did_hit_collision boolean Flags whether the player hit a collision during the simulation.
---@field obb_mins vector Player's bounding box's minimum points.
---@field obb_maxs vector Player's bounding box's maximum points.
---@field move vector
---@field simulation_ticks number The number of ticks over which the simulation was conducted.
---@field gravity_per_apply number Indicates the applied gravitational force during the simulation.
---@field original_max_speed number The player's maximum speed before the simulation.
---@field max_speed number The maximum speed achieved by the player during the simulation.
---@field is_speed_cropped boolean
---@field velocity_modifier number `m_flVelocityModifier` value of the player after simulation.
---@field duck_speed number The simulated speed at which the player can be crouching.
---@field stamina number `m_flStamina` value of the player after simulation.
---@field surface_friction number `m_surfaceFriction` value of the player after simulation.
---@field trace trace Post-simulation trace object.
local sim_ctx = {}

---Simulates the player's movement for a specified number of ticks.
---If not specified, it defaults to simulating for 1 tick.
---@param ticks number? Number of ticks to simulate. Defaults to 1. Optional.
function sim_ctx:think(ticks) end
