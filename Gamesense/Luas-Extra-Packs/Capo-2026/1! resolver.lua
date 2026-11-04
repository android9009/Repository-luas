---@diagnostic disable: undefined-global
local ffi = require 'ffi'
local crr_t = ffi.typeof('void*(__thiscall*)(void*)')
local cr_t = ffi.typeof('void*(__thiscall*)(void*)')
local gm_t = ffi.typeof('const void*(__thiscall*)(void*)')
local gsa_t = ffi.typeof('int(__fastcall*)(void*, void*, int)')

ffi.cdef[[
    struct animation_layer_t {
        char  pad_0000[20];
        uint32_t m_nOrder; //0x0014
        uint32_t m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030 // player's thisptr
        char  pad_0038[4]; //0x0034
    };

    struct animstate_t1 {
        char pad[3];
        char m_bForceWeaponUpdate; //0x4
        char pad1[91];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[4];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[4];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[4];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[4];
        float m_flUnknownFloat1; //0xD4
        char pad6[8];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        char pad7[2];
        float m_flTimeSinceInAir; //0x10C
        float m_flLastOriginZ; //0x110
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x114
        float m_flStopToFullRunningFraction; //0x118
        char pad8[4];
        float m_flMagicFraction; //0x11C
        char pad9[60];
        float m_flWorldForce; //0x15C
        char pad10[462];
        float m_flMaxYaw; //0x334
    };
]]

local classptr = ffi.typeof('void***')
local entity_list_interface = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 not found', 2)
local entity_list_ptr = ffi.cast(classptr, entity_list_interface) or error('entity_list_interface is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', entity_list_ptr[0][3]) or error('get_client_entity is nil', 2)

local model_info_interface = client.create_interface('engine.dll', 'VModelInfoClient004')
local model_info_ptr = ffi.cast(classptr, model_info_interface) or error('model_info_interface is nil', 2)
local get_studio_model = ffi.cast('void*(__thiscall*)(void*, const void*)', model_info_ptr[0][32])

local seq_activity_signature = client.find_signature('client_panorama.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83')

function get_entity_ptr(entity_index)
    return get_client_entity(entity_list_ptr, entity_index)
end

function get_animation_layer(entity_ptr, layer_index)
    layer_index = layer_index or 1
    entity_ptr = ffi.cast(classptr, entity_ptr)
    return ffi.cast('struct animation_layer_t**', ffi.cast('char*', entity_ptr) + 0x2990)[0][layer_index]
end

function get_animation_state(entity_ptr)
    if entity_ptr then
        entity_ptr = ffi.cast(classptr, entity_ptr)
        return ffi.cast('struct animstate_t1*', ffi.cast('char*', entity_ptr) + 0x3914)
    end
    return nil
end

function get_entity_model(entity_ptr)
    if entity_ptr then
        entity_ptr = ffi.cast(classptr, entity_ptr)
        local client_unknown = ffi.cast(crr_t, entity_ptr[0][0])(entity_ptr)
        if client_unknown then
            client_unknown = ffi.cast(classptr, client_unknown)
            local renderable = ffi.cast(cr_t, client_unknown[0][5])(client_unknown)
            if renderable then
                renderable = ffi.cast(classptr, renderable)
                return ffi.cast(gm_t, renderable[0][8])(renderable)
            end
        end
    end
    return nil
end

local VectorMath = {}

VectorMath.Create = function(x, y, z)
    return {x = x or 0, y = y or 0, z = z or 0}
end

VectorMath.Distance = function(v1, v2)
    return math.sqrt((v2.x - v1.x)^2 + (v2.y - v1.y)^2 + (v2.z - v1.z)^2)
end

VectorMath.Normalize = function(v)
    local length = math.sqrt(v.x^2 + v.y^2 + v.z^2)
    if length == 0 then return {x = 0, y = 0, z = 0} end
    return {x = v.x/length, y = v.y/length, z = v.z/length}
end

VectorMath.DotProduct = function(v1, v2)
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

VectorMath.CrossProduct = function(v1, v2)
    return {
        x = v1.y * v2.z - v1.z * v2.y,
        y = v1.z * v2.x - v1.x * v2.z,
        z = v1.x * v2.y - v1.y * v2.x
    }
end

VectorMath.VectorAngles = function(forward)
    local pitch, yaw
    if forward.x == 0 and forward.y == 0 then
        if forward.z > 0 then pitch = 270 else pitch = 90 end
        yaw = 0
    else
        yaw = math.deg(math.atan2(forward.y, forward.x))
        local hyp = math.sqrt(forward.x * forward.x + forward.y * forward.y)
        pitch = math.deg(math.atan2(-forward.z, hyp))
    end
    return {pitch = pitch, yaw = yaw}
end

VectorMath.AngleVectors = function(angles)
    local sp = math.sin(math.rad(angles.pitch))
    local sy = math.sin(math.rad(angles.yaw))
    local cp = math.cos(math.rad(angles.pitch))
    local cy = math.cos(math.rad(angles.yaw))
    
    return {
        x = cp * cy,
        y = cp * sy,
        z = -sp
    }
end

VectorMath.CreateMatrix = function(rows, cols, default_val)
    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = default_val or 0
        end
    end
    return matrix
end

VectorMath.CreateYawRotationMatrix = function(yaw_deg)
    local yaw_rad = math.rad(yaw_deg)
    local sin_yaw = math.sin(yaw_rad)
    local cos_yaw = math.cos(yaw_rad)
    
    local matrix = VectorMath.CreateMatrix(3, 3)
    matrix[1][1] = cos_yaw
    matrix[1][2] = -sin_yaw
    matrix[1][3] = 0
    matrix[2][1] = sin_yaw
    matrix[2][2] = cos_yaw
    matrix[2][3] = 0
    matrix[3][1] = 0
    matrix[3][2] = 0
    matrix[3][3] = 1
    
    return matrix
end

VectorMath.TransformVector = function(v, matrix)
    return {
        x = v.x * matrix[1][1] + v.y * matrix[1][2] + v.z * matrix[1][3],
        y = v.x * matrix[2][1] + v.y * matrix[2][2] + v.z * matrix[2][3],
        z = v.x * matrix[3][1] + v.y * matrix[3][2] + v.z * matrix[3][3]
    }
end

local AngleTools = {}

AngleTools.NormalizeAngle = function(angle)
    angle = (angle + 180) % 360 - 180
    return angle
end

AngleTools.NormalizeYaw = function(yaw)
    yaw = yaw % 360
    if yaw < 0 then yaw = yaw + 360 end
    return yaw
end

AngleTools.ClampAngle = function(angle, min, max)
    if angle < min then return min end
    if angle > max then return max end
    return angle
end

AngleTools.AngleDiff = function(a1, a2)
    local diff = AngleTools.NormalizeAngle(a1 - a2)
    return diff
end

local PlayerState = {
    INVALID = 0,
    STANDING = 1,
    MOVING = 2,
    AIR = 3,
    CROUCHING = 4,
    CROUCH_MOVING = 5,
    AIR_CROUCH = 6,
    RUSHING = 7
}

local StateNames = {
    [0] = "INVALID",
    [1] = "STANDING",
    [2] = "MOVING",
    [3] = "AIR",
    [4] = "CROUCHING",
    [5] = "CROUCH_MOVING",
    [6] = "AIR_CROUCH",
    [7] = "RUSHING"
}

local FL_ONGROUND = bit.lshift(1, 0)
local FL_DUCKING = bit.lshift(1, 1)
local MIN_RUSH_SPEED = 180
local MAX_RUSH_DISTANCE = 800

local PlayerDatabase = {}
local ResolveHistory = {}
local ResolveProgress = {}
local ResolveCache = {}

function InitPlayerData(player_idx)
    if not PlayerDatabase[player_idx] then
        PlayerDatabase[player_idx] = {
            entity_ptr = nil,
            state = PlayerState.INVALID,
            previous_state = PlayerState.INVALID,
            position = VectorMath.Create(),
            velocity = VectorMath.Create(),
            aim_angles = {pitch = 0, yaw = 0},
            lby_yaw = 0,
            desync_angle = 0,
            desync_side = 0,
            ground_time = 0,
            air_time = 0,
            crouch_time = 0,
            moving_time = 0,
            still_time = 0,
            last_update_time = 0,
            animation_layers = {},
            optimal_offsets = {
                [PlayerState.STANDING] = 0,
                [PlayerState.MOVING] = 0,
                [PlayerState.AIR] = 35,
                [PlayerState.CROUCHING] = -35,
                [PlayerState.CROUCH_MOVING] = 0,
                [PlayerState.AIR_CROUCH] = 58,
                [PlayerState.RUSHING] = 0
            },
            weights = {
                [PlayerState.STANDING] = 1,
                [PlayerState.MOVING] = 1,
                [PlayerState.AIR] = 1,
                [PlayerState.CROUCHING] = 1,
                [PlayerState.CROUCH_MOVING] = 1,
                [PlayerState.AIR_CROUCH] = 1,
                [PlayerState.RUSHING] = 1
            }
        }
    end
    return PlayerDatabase[player_idx]
end

function InitResolveHistory(player_idx)
    if not ResolveHistory[player_idx] then
        ResolveHistory[player_idx] = {
            hits = 0,
            misses = 0,
            hits_by_state = {},
            misses_by_state = {},
            successful_yaws = {},
            failed_yaws = {},
            last_hit_state = nil,
            total_shots = 0,
            resolve_confidence = 0
        }
        
        for _, state in pairs(PlayerState) do
            if type(state) == "number" and state ~= 0 then
                ResolveHistory[player_idx].hits_by_state[state] = 0
                ResolveHistory[player_idx].misses_by_state[state] = 0
            end
        end
    end
    return ResolveHistory[player_idx]
end

function InitResolveProgress(player_idx)
    if not ResolveProgress[player_idx] then
        ResolveProgress[player_idx] = {
            stage = 1,
            progress = 0,
            start_time = globals.realtime(),
            last_update = globals.realtime(),
            is_resolved = false
        }
    end
    return ResolveProgress[player_idx]
end

function GetPlayerState(player_idx)
    local player_data = InitPlayerData(player_idx)
    local current_time = globals.curtime()
    
    if current_time - player_data.last_update_time < 0.01 then
        return player_data
    end
    
    local entity_ptr = get_entity_ptr(player_idx)
    if not entity_ptr then return player_data end
    
    player_data.entity_ptr = entity_ptr
    
    local origin = {entity.get_origin(player_idx)}
    player_data.position = VectorMath.Create(origin[1], origin[2], origin[3])
    
    local vel_x = entity.get_prop(player_idx, "m_vecVelocity[0]") or 0
    local vel_y = entity.get_prop(player_idx, "m_vecVelocity[1]") or 0
    local vel_z = entity.get_prop(player_idx, "m_vecVelocity[2]") or 0
    player_data.velocity = VectorMath.Create(vel_x, vel_y, vel_z)
    
    local eye_angles = {entity.get_prop(player_idx, "m_angEyeAngles")}
    player_data.aim_angles = {pitch = eye_angles[1] or 0, yaw = eye_angles[2] or 0}
    
    player_data.lby_yaw = entity.get_prop(player_idx, "m_flLowerBodyYawTarget") or 0
    player_data.desync_angle = AngleTools.AngleDiff(player_data.aim_angles.yaw, player_data.lby_yaw)
    player_data.desync_side = player_data.desync_angle > 0 and 1 or 2
    
    local anim_state = get_animation_state(entity_ptr)
    if anim_state then
        player_data.eye_yaw = anim_state.m_flEyeYaw
        player_data.goal_feet_yaw = anim_state.m_flGoalFeetYaw
        player_data.current_feet_yaw = anim_state.m_flCurrentFeetYaw
        player_data.speed_2d = anim_state.m_flSpeed2D
    end
    
    for i = 0, 13 do
        local layer = get_animation_layer(entity_ptr, i)
        player_data.animation_layers[i] = {
            sequence = layer.m_nSequence,
            prev_cycle = layer.m_flPrevCycle,
            weight = layer.m_flWeight,
            playback_rate = layer.m_flPlaybackRate,
            cycle = layer.m_flCycle
        }
    end
    
    local flags = entity.get_prop(player_idx, "m_fFlags") or 0
    local on_ground = bit.band(flags, FL_ONGROUND) ~= 0
    local ducking = bit.band(flags, FL_DUCKING) ~= 0
    local speed_2d = math.sqrt(vel_x * vel_x + vel_y * vel_y)
    local is_moving = speed_2d > 5
    
    local delta_time = current_time - player_data.last_update_time
    
    if on_ground then
        player_data.ground_time = player_data.ground_time + delta_time
        player_data.air_time = 0
    else
        player_data.air_time = player_data.air_time + delta_time
        player_data.ground_time = 0
    end
    
    if ducking then
        player_data.crouch_time = player_data.crouch_time + delta_time
    else
        player_data.crouch_time = 0
    end
    
    if is_moving then
        player_data.moving_time = player_data.moving_time + delta_time
        player_data.still_time = 0
    else
        player_data.still_time = player_data.still_time + delta_time
        player_data.moving_time = 0
    end
    
    player_data.previous_state = player_data.state
    
    if not on_ground then
        if ducking then
            player_data.state = PlayerState.AIR_CROUCH
        else
            player_data.state = PlayerState.AIR
        end
    else if ducking then
            if is_moving then
                player_data.state = PlayerState.CROUCH_MOVING
            else
                player_data.state = PlayerState.CROUCHING
            end
        else
            if is_moving then
                player_data.state = PlayerState.MOVING
            else
                player_data.state = PlayerState.STANDING
            end
        end
    end
    
    local local_player = entity.get_local_player()
    if local_player and speed_2d > MIN_RUSH_SPEED then
        local local_origin = {entity.get_origin(local_player)}
        local local_pos = VectorMath.Create(local_origin[1], local_origin[2], local_origin[3])
        
        local distance = VectorMath.Distance(player_data.position, local_pos)
        
        if distance < MAX_RUSH_DISTANCE then
            local direction = {
                x = local_pos.x - player_data.position.x,
                y = local_pos.y - player_data.position.y,
                z = local_pos.z - player_data.position.z
            }
            
            direction = VectorMath.Normalize(direction)
    
            local velocity_norm = VectorMath.Normalize(player_data.velocity)
    
            local dot_product = VectorMath.DotProduct(velocity_norm, direction)
            
            if dot_product > 0.5 then
                player_data.state = PlayerState.RUSHING
            end
        end
    end
    
    player_data.last_update_time = current_time
    
    return player_data
end

function CalculateOptimalOffset(player_idx, state)
    local player_data = PlayerDatabase[player_idx]
    if not player_data then return 0 end
    
    local offset = player_data.optimal_offsets[state] or 0
    
    if state == PlayerState.STANDING or state == PlayerState.CROUCHING then
        local layer6 = player_data.animation_layers[6]
        if layer6 then
            local playback_rate = layer6.playback_rate or 0
            local playback_str = tostring(playback_rate)
            
            local digits = {}
            for digit in string.gmatch(playback_str, "%d") do
                table.insert(digits, tonumber(digit))
            end
            
            if #digits >= 8 then
                local anim45 = tonumber(digits[4] .. digits[5]) or 0
                local anim67 = tonumber(digits[6] .. digits[7]) or 0
                local diff = math.abs(anim45 - anim67)
                
                if diff > 0 then
                    if state == PlayerState.STANDING then
                        offset = AngleTools.ClampAngle(58 - (diff * 0.5), -58, 58)
                    else -- CROUCHING
                        offset = AngleTools.ClampAngle(-35 - (diff * 0.2), -58, 58)
                    end
                end
            end
        end
    end
    
    local history = ResolveHistory[player_idx]
    if history and history.hits_by_state[state] > 0 then
        local success_rate = history.hits_by_state[state] / (history.hits_by_state[state] + history.misses_by_state[state])
        
        if success_rate > 0.6 and #history.successful_yaws > 0 then
            for i = #history.successful_yaws, 1, -1 do
                local entry = history.successful_yaws[i]
                if entry.state == state then
                    offset = entry.offset
                    break
                end
            end
        end
    end
    
    return offset
end

function ResolvePlayer(player_idx)
    local player_data = GetPlayerState(player_idx)
    local progress_data = InitResolveProgress(player_idx)
    
    if player_data.state == PlayerState.INVALID then return end
    
    local current_time = globals.realtime()
    local time_delta = current_time - progress_data.last_update
    
    local base_increase = 5 * time_delta
    local state_multiplier = 1.0
    
    if player_data.state == PlayerState.STANDING then
        state_multiplier = 2.0  -- Easiest
    elseif player_data.state == PlayerState.AIR then
        state_multiplier = 1.5  -- Easy
    elseif player_data.state == PlayerState.RUSHING then
        state_multiplier = 0.5  -- Hard
    end
    
    local history = ResolveHistory[player_idx]
    local confidence_multiplier = 1.0
    
    if history then
        local total = history.hits + history.misses
        if total > 0 then
            local hit_rate = history.hits / total
            confidence_multiplier = 0.5 + hit_rate
        end
    end
    
    local progress_increase = base_increase * state_multiplier * confidence_multiplier
    progress_data.progress = math.min(100, progress_data.progress + progress_increase)
    
    if progress_data.progress < 25 then
        progress_data.stage = 1
    elseif progress_data.progress < 50 then
        progress_data.stage = 2
    elseif progress_data.progress < 75 then
        progress_data.stage = 3
    elseif progress_data.progress < 100 then
        progress_data.stage = 4
    else
        progress_data.stage = 5
        progress_data.is_resolved = true
    end
    
    local optimal_offset = CalculateOptimalOffset(player_idx, player_data.state)
    
    local base_angle = player_data.lby_yaw

    local rotation_matrix = VectorMath.CreateYawRotationMatrix(optimal_offset)

    local forward = VectorMath.AngleVectors({pitch = 0, yaw = base_angle})

    local transformed = VectorMath.TransformVector(forward, rotation_matrix)
    
    local resolved_angles = VectorMath.VectorAngles(transformed)
    local resolved_yaw = resolved_angles.yaw
    
    local blend_factor = progress_data.progress / 100
    resolved_yaw = base_angle + optimal_offset * (1 - blend_factor) + (resolved_yaw - base_angle) * blend_factor
    
    plist.set(player_idx, "Force Body Yaw", true)
    plist.set(player_idx, "Force Body Yaw Value", resolved_yaw)
    
    if player_data.aim_angles.pitch < -89 or player_data.aim_angles.pitch > 89 then
        plist.set(player_idx, "Force Pitch", true)
        plist.set(player_idx, "Force Pitch Value", 0)
    else
        plist.set(player_idx, "Force Pitch", false)
    end
    
    ResolveCache[player_idx] = {
        yaw = resolved_yaw,
        offset = optimal_offset,
        side = player_data.desync_side,
        state = player_data.state,
        state_name = StateNames[player_data.state],
        progress = progress_data.progress,
        stage = progress_data.stage,
        is_resolved = progress_data.is_resolved,
        confidence = history and history.resolve_confidence or 0
    }
    
    progress_data.last_update = current_time
    ResolveProgress[player_idx] = progress_data
    
    return resolved_yaw
end

function UpdateLearningData(player_idx, hit_success, headshot)
    local player_data = PlayerDatabase[player_idx]
    local history = InitResolveHistory(player_idx)
    local cache = ResolveCache[player_idx]
    
    if not player_data or not cache then return end
    
    local state = player_data.state
    local offset = cache.offset
    
    history.total_shots = history.total_shots + 1
    
    if hit_success then
        history.hits = history.hits + 1
        history.hits_by_state[state] = (history.hits_by_state[state] or 0) + 1
        
        table.insert(history.successful_yaws, {
            yaw = cache.yaw,
            offset = offset,
            state = state,
            time = globals.realtime(),
            headshot = headshot
        })
        
        local weight = headshot and 2.0 or 1.0
        history.resolve_confidence = math.min(100, history.resolve_confidence + (headshot and 20 or 10))
        player_data.weights[state] = player_data.weights[state] + weight
        
        local learning_rate = 0.3
        player_data.optimal_offsets[state] = player_data.optimal_offsets[state] * (1 - learning_rate) + offset * learning_rate
    else
        history.misses = history.misses + 1
        history.misses_by_state[state] = (history.misses_by_state[state] or 0) + 1
        
        table.insert(history.failed_yaws, {
            yaw = cache.yaw,
            offset = offset,
            state = state,
            time = globals.realtime()
        })
        
        history.resolve_confidence = math.max(0, history.resolve_confidence - 15)
        
        local learning_rate = 0.2
        local correction = -offset * 0.5
        player_data.optimal_offsets[state] = player_data.optimal_offsets[state] * (1 - learning_rate) + correction * learning_rate
    end
    
    while #history.successful_yaws > 20 do
        table.remove(history.successful_yaws, 1)
    end
    while #history.failed_yaws > 20 do
        table.remove(history.failed_yaws, 1)
    end
    
    ResolveHistory[player_idx] = history
    PlayerDatabase[player_idx] = player_data
end

local ui_main_color = {130, 60, 240}
local menu_color_picker = ui.new_color_picker("Rage", "Other", "Angel Resolver Color", ui_main_color[1], ui_main_color[2], ui_main_color[3], 255)

local ui_elements = {
    header = ui.new_label("Rage", "Other", "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
    title = ui.new_label("Rage", "Other", "𓆩♡𓆪 Angel 𓆩♡𓆪"),
    enable = ui.new_checkbox("Rage", "Other", "Enable Resolver"),
    debug_logs = ui.new_checkbox("Rage", "Other", "Debug ~ Logs"),
    visualize = ui.new_checkbox("Rage", "Other", "Visualize ~ Resolver"),
    esp_flags = ui.new_checkbox("Rage", "Other", "ESP ~ Flags"),
    
    state_header = ui.new_label("Rage", "Other", "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
    state_title = ui.new_label("Rage", "Other", "-=- State Analysis -=-"),
    auto_learning = ui.new_checkbox("Rage", "Other", "Auto-Learning System"),
    learning_speed = ui.new_slider("Rage", "Other", "Learning Speed", 1, 100, 50, true, "%"),
    
    air_state = ui.new_checkbox("Rage", "Other", "In Air ~ State"),
    air_offset = ui.new_slider("Rage", "Other", "Air Offset", -58, 58, 35, true, "°"),
    crouch_state = ui.new_checkbox("Rage", "Other", "Crouch ~ State"),
    crouch_offset = ui.new_slider("Rage", "Other", "Crouch Offset", -58, 58, -35, true, "°"),
    rush_state = ui.new_checkbox("Rage", "Other", "Anti-Rush ~ (Zeus DT)"),
    rush_offset = ui.new_slider("Rage", "Other", "Rush Offset", -58, 58, 0, true, "°"),
    
    perf_header = ui.new_label("Rage", "Other", "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
    perf_title = ui.new_label("Rage", "Other", "Performance"),
    fast_updates = ui.new_checkbox("Rage", "Other", "Optimized -=- Tick -=- Updates"),
    update_rate = ui.new_slider("Rage", "Other", "Update Rate", 1, 128, 64, true, "tick"),
    predictive_aim = ui.new_checkbox("Rage", "Other", "Prediction ~ (Recommended)"),
    prediction_strength = ui.new_slider("Rage", "Other", "Prediction Strength", 0, 100, 50, true, "%"),
    
    footer = ui.new_label("Rage", "Other", "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),
    credits = ui.new_label("Rage", "Other", "Angel v2.0 | Recode ~ discord.gg/KrGnPn8B")
}

local default_refs = {
    ["Anti-Aim Correction"] = ui.reference("Rage", "Other", "Anti-Aim Correction"),
    ["ResetAll"] = ui.reference("Players", "Players", "Reset All"),
    ["ForceBodyYaw"] = ui.reference("Players", "Adjustments", "Force Body Yaw"),
    ["CorrectionActive"] = ui.reference("Players", "Adjustments", "Correction Active")
}

function UpdateUIVisibility()
    local enabled = ui.get(ui_elements.enable)

    ui.set_visible(ui_elements.header, enabled)
    ui.set_visible(ui_elements.title, enabled)
    ui.set_visible(ui_elements.debug_logs, enabled)
    ui.set_visible(ui_elements.visualize, enabled)
    ui.set_visible(ui_elements.esp_flags, enabled)
    
    ui.set_visible(ui_elements.state_header, enabled)
    ui.set_visible(ui_elements.state_title, enabled)
    ui.set_visible(ui_elements.auto_learning, enabled)
    
    local auto_learning = enabled and ui.get(ui_elements.auto_learning)
    ui.set_visible(ui_elements.learning_speed, auto_learning)
    
    ui.set_visible(ui_elements.air_state, enabled)
    local air_visible = enabled and ui.get(ui_elements.air_state) and not auto_learning
    ui.set_visible(ui_elements.air_offset, air_visible)
    
    ui.set_visible(ui_elements.crouch_state, enabled)
    local crouch_visible = enabled and ui.get(ui_elements.crouch_state) and not auto_learning
    ui.set_visible(ui_elements.crouch_offset, crouch_visible)
    
    ui.set_visible(ui_elements.rush_state, enabled)
    local rush_visible = enabled and ui.get(ui_elements.rush_state) and not auto_learning
    ui.set_visible(ui_elements.rush_offset, rush_visible)
    
    ui.set_visible(ui_elements.perf_header, enabled)
    ui.set_visible(ui_elements.perf_title, enabled)
    ui.set_visible(ui_elements.fast_updates, enabled)
    
    local updates_visible = enabled and ui.get(ui_elements.fast_updates)
    ui.set_visible(ui_elements.update_rate, updates_visible)
    
    ui.set_visible(ui_elements.predictive_aim, enabled)
    local prediction_visible = enabled and ui.get(ui_elements.predictive_aim)
    ui.set_visible(ui_elements.prediction_strength, prediction_visible)
    
    ui.set_visible(ui_elements.footer, enabled)
    ui.set_visible(ui_elements.credits, enabled)
    
    ui.set_visible(default_refs["ForceBodyYaw"], not enabled)
    ui.set_visible(default_refs["CorrectionActive"], not enabled)
    
    if not enabled then
        ui.set(default_refs["ResetAll"], true)
    end
end

local function rgba_to_hex(r, g, b, a)
    return string.format("%02X%02X%02X%02X", r, g, b, a)
end

fade_label = function(time, string, r, g, b, a)
    local t_out, t_out_iter = {}, 1
    for i = 1, #string do
        local iter = (i - 1) / (#string - 1) + time
        local alpha = math.abs(math.sin(iter)) * a
        t_out[t_out_iter] = "\a" .. rgba_to_hex(r, g, b, alpha)
        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end
    return t_out
end

rainbow_label = function(time, string)
    local t_out, t_out_iter = {}, 1
    for i = 1, #string do
        local iter = (i - 1) / #string + time
        local r = math.floor(math.sin(iter * 2) * 127 + 128)
        local g = math.floor(math.sin(iter * 2 + 2) * 127 + 128)
        local b = math.floor(math.sin(iter * 2 + 4) * 127 + 128)
        t_out[t_out_iter] = "\a" .. rgba_to_hex(r, g, b, 255)
        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end
    return t_out
end

wave_label = function(time, string, r, g, b, a)
    local t_out, t_out_iter = {}, 1
    for i = 1, #string do
        local iter = (i - 1) / #string + time
        local r_wave = r + math.sin(iter * 3) * 50
        local g_wave = g + math.sin(iter * 3 + 2) * 50
        local b_wave = b + math.sin(iter * 3 + 4) * 50
        t_out[t_out_iter] = "\a" .. rgba_to_hex(math.floor(r_wave), math.floor(g_wave), math.floor(b_wave), a)
        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end
    return t_out
end

glitch_label = function(time, string)
    local t_out, t_out_iter = {}, 1
    for i = 1, #string do
        if math.random() > 0.7 then
            local r, g, b = math.random(255), math.random(255), math.random(255)
            t_out[t_out_iter] = "\a" .. rgba_to_hex(r, g, b, 255)
        else
            t_out[t_out_iter] = "\aFFFFFF"
        end
        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end
    return t_out
end

shadow_label = function(time, string, r, g, b, a)
    local t_out, t_out_iter = {}, 1
    for i = 1, #string do
        local iter = (i - 1) / #string + time
        local shadow_a = math.abs(math.sin(iter)) * 100
        t_out[t_out_iter] = "\a" .. rgba_to_hex(0, 0, 0, shadow_a)
        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end
    return t_out
end

function UpdateTitleColors()
    local r, g, b = ui.get(menu_color_picker)
    local time = globals.realtime() * 2

    local faded_title = table.concat(fade_label(time, "</3 ~ Angel ~ </3", r, g, b, 255))
    local faded_state_title = table.concat(fade_label(time, "-=- State Analysis -=-", r, g, b, 255))
    local faded_perf_title = table.concat(fade_label(time, "Performance", r, g, b, 255))
    local faded_credits = table.concat(fade_label(time, "discord.gg/KrGnPn8B", r, g, b, 255))
    local faded_header = table.concat(fade_label(time, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", r, g, b, 255))

    ui.set(ui_elements.title, faded_title)
    ui.set(ui_elements.state_title, faded_state_title)
    ui.set(ui_elements.perf_title, faded_perf_title)
    ui.set(ui_elements.credits, "Angel Resolver v2.0 | Recode ~ " .. faded_credits)
    ui.set(ui_elements.header, faded_header)
    ui.set(ui_elements.state_header, faded_header)
    ui.set(ui_elements.perf_header, faded_header)
    ui.set(ui_elements.footer, faded_header)
end

ui.set_callback(menu_color_picker, UpdateTitleColors)
ui.set_callback(ui_elements.enable, UpdateUIVisibility)
ui.set_callback(ui_elements.auto_learning, UpdateUIVisibility)
ui.set_callback(ui_elements.air_state, UpdateUIVisibility)
ui.set_callback(ui_elements.crouch_state, UpdateUIVisibility)
ui.set_callback(ui_elements.rush_state, UpdateUIVisibility)
ui.set_callback(ui_elements.fast_updates, UpdateUIVisibility)
ui.set_callback(ui_elements.predictive_aim, UpdateUIVisibility)

UpdateUIVisibility()
UpdateTitleColors()

function UpdateResolver()
    if not ui.get(ui_elements.enable) then
        return
    end
    
    local current_tick = globals.tickcount()
    local update_frequency = ui.get(ui_elements.fast_updates) and math.ceil(128 / ui.get(ui_elements.update_rate)) or 1
    
    if ui.get(ui_elements.fast_updates) and current_tick % update_frequency ~= 0 then
        return
    end
    
    local players = entity.get_players(true)
    if not players then return end
    
    for i, player_idx in ipairs(players) do
        ResolvePlayer(player_idx)
    end
end

client.set_event_callback("bullet_impact", function(e)
    if not ui.get(ui_elements.enable) then return end
    if not ui.get(ui_elements.auto_learning) then return end
    
    local shooter = client.userid_to_entindex(e.userid)
    if not shooter or shooter ~= entity.get_local_player() then return end
    
    local impact_pos = {e.x, e.y, e.z}
    local local_pos = {entity.get_origin(shooter)}
    
    local dir = {
        x = impact_pos[1] - local_pos[1],
        y = impact_pos[2] - local_pos[2],
        z = impact_pos[3] - local_pos[3]
    }
    
    local length = math.sqrt(dir.x^2 + dir.y^2 + dir.z^2)
    if length > 0 then
        dir.x = dir.x / length
        dir.y = dir.y / length
        dir.z = dir.z / length
    end
    
    local closest_player = nil
    local closest_dist = 100
    
    local players = entity.get_players(true)
    for i, player_idx in ipairs(players) do
        local head_pos = {entity.hitbox_position(player_idx, 0)}
        
        if head_pos and #head_pos >= 3 then
            local to_player = {
                x = head_pos[1] - local_pos[1],
                y = head_pos[2] - local_pos[2],
                z = head_pos[3] - local_pos[3]
            }
            
            local proj_length = to_player.x * dir.x + to_player.y * dir.y + to_player.z * dir.z
            
            if proj_length > 0 then
                local point = {
                    x = local_pos[1] + dir.x * proj_length,
                    y = local_pos[2] + dir.y * proj_length,
                    z = local_pos[3] + dir.z * proj_length
                }
                
                local dist = math.sqrt(
                    (point.x - head_pos[1])^2 +
                    (point.y - head_pos[2])^2 +
                    (point.z - head_pos[3])^2
                )
                
                if dist < closest_dist then
                    closest_dist = dist
                    closest_player = player_idx
                end
            end
        end
    end
    
    if closest_player then
        UpdateLearningData(closest_player, false, false)
    end
end)

client.set_event_callback("player_hurt", function(e)
    if not ui.get(ui_elements.enable) then return end
    
    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)
    
    if attacker and victim and attacker == entity.get_local_player() then
        local is_headshot = e.hitgroup == 1
        UpdateLearningData(victim, true, is_headshot)
        
        if ui.get(ui_elements.debug_logs) then
            local cache = ResolveCache[victim]
            client.color_log(0, 255, 0, string.format(
                "[Angel's] Hit %s in the %s for %d damage (Resolve Stage: %d/%d, State: %s)",
                entity.get_player_name(victim),
                e.hitgroup == 1 and "head" or "body",
                e.dmg_health,
                cache and cache.stage or 0,
                5,
                cache and cache.state_name or "UNKNOWN"
            ))
        end
    end
end)

client.set_event_callback("aim_miss", function(e)
    if not ui.get(ui_elements.enable) then return end
    
    local victim = e.target
    if victim then
        UpdateLearningData(victim, false, false)
        
        if ui.get(ui_elements.debug_logs) then
            local cache = ResolveCache[victim]
            client.color_log(255, 0, 0, string.format(
                "[Angel's] Missed %s (%s) due to %s (Resolve Stage: %d/%d, State: %s)",
                entity.get_player_name(victim),
                e.hitgroup == 1 and "head" or "body",
                e.reason,
                cache and cache.stage or 0,
                5,
                cache and cache.state_name or "UNKNOWN"
            ))
        end
    end
end)

function DrawResolverVisualizations()
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.visualize) then return end
    
    local local_player = entity.get_local_player()
    if not local_player then return end
    
    local local_origin = {entity.get_origin(local_player)}
    if not local_origin or #local_origin < 3 then return end
    
    local players = entity.get_players(true)
    for i, player_idx in ipairs(players) do
        local cache = ResolveCache[player_idx]
        if cache then
            local enemy_origin = {entity.get_origin(player_idx)}
            local enemy_head = {entity.hitbox_position(player_idx, 1)}
            
            if enemy_origin and enemy_head and #enemy_origin >= 3 and #enemy_head >= 3 then
                local screen_local = {renderer.world_to_screen(local_origin[1], local_origin[2], local_origin[3] + 62)}
                local screen_head = {renderer.world_to_screen(enemy_head[1], enemy_head[2], enemy_head[3])}
                local screen_origin = {renderer.world_to_screen(enemy_origin[1], enemy_origin[2], enemy_origin[3] + 56)}
                
                if screen_local[1] and screen_head[1] and screen_origin[1] then
                    local r, g, b = 255, 0, 0
                    if cache.progress > 75 then
                        r, g, b = 0, 255, 0
                    elseif cache.progress > 50 then
                        r, g, b = 255, 255, 0
                    elseif cache.progress > 25 then
                        r, g, b = 255, 165, 0
                    end
                    renderer.line(screen_local[1], screen_local[2], screen_head[1], screen_head[2], r, g, b, 255)

                    local yaw_rad = math.rad(cache.yaw)
                    local cos_yaw = math.cos(yaw_rad)
                    local sin_yaw = math.sin(yaw_rad)
                    
                    local line_length = 30
                    local end_x = screen_origin[1] + cos_yaw * line_length
                    local end_y = screen_origin[2] + sin_yaw * line_length
                    
                    renderer.line(screen_origin[1], screen_origin[2], end_x, end_y, r, g, b, 255)
                    
                    local progress_text = string.format("Resolving %d%%", math.floor(cache.progress))
                    if cache.is_resolved then
                        progress_text = "RESOLVED"
                    end
                    
                    renderer.text(screen_head[1], screen_head[2] - 15, r, g, b, 255, "c", 0, progress_text)
                    
                    renderer.text(screen_head[1], screen_head[2] - 30, 255, 255, 255, 255, "c", 0, cache.state_name)
                    
                    if ui.get(ui_elements.predictive_aim) then
                        local player_data = PlayerDatabase[player_idx]
                        if player_data and player_data.velocity then
                            local pred_time = 0.2 * (ui.get(ui_elements.prediction_strength) / 100)
                            local pred_x = enemy_origin[1] + player_data.velocity.x * pred_time
                            local pred_y = enemy_origin[2] + player_data.velocity.y * pred_time
                            local pred_z = enemy_origin[3] + player_data.velocity.z * pred_time
                            
                            local screen_pred = {renderer.world_to_screen(pred_x, pred_y, pred_z)}
                            if screen_pred[1] then
                                renderer.circle_outline(screen_pred[1], screen_pred[2], 255, 0, 255, 200, 5, 0, 1, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end

client.register_esp_flag("MATRIX", 130, 60, 240, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local cache = ResolveCache[player_idx]
    return cache and cache.is_resolved
end)

client.register_esp_flag("RESOLVING", 255, 165, 0, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local cache = ResolveCache[player_idx]
    if cache and not cache.is_resolved then
        return string.format("%d/4", cache.stage)
    end
    return false
end)

client.register_esp_flag("R", 255, 255, 255, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local cache = ResolveCache[player_idx]
    return cache and cache.side == 1
end)

client.register_esp_flag("L", 255, 255, 255, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local cache = ResolveCache[player_idx]
    return cache and cache.side == 2
end)

client.register_esp_flag("AIR", 173, 216, 230, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local player_data = PlayerDatabase[player_idx]
    return player_data and player_data.state == PlayerState.AIR
end)

client.register_esp_flag("CROUCH", 144, 238, 144, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local player_data = PlayerDatabase[player_idx]
    return player_data and (player_data.state == PlayerState.CROUCHING or player_data.state == PlayerState.CROUCH_MOVING)
end)

client.register_esp_flag("RUSH", 255, 105, 180, function(player_idx)
    if not ui.get(ui_elements.enable) or not ui.get(ui_elements.esp_flags) then return false end
    
    local player_data = PlayerDatabase[player_idx]
    return player_data and player_data.state == PlayerState.RUSHING
end)

client.set_event_callback("net_update_end", UpdateResolver)
client.set_event_callback("paint", DrawResolverVisualizations)
client.set_event_callback("paint_ui", UpdateTitleColors)


client.set_event_callback("shutdown", function()
    ui.set_visible(default_refs["ForceBodyYaw"], true)
    ui.set_visible(default_refs["CorrectionActive"], true)
    ui.set(default_refs["ResetAll"], true)
end)

UpdateUIVisibility()

client.color_log(130, 60, 240, "[Angel] Loaded successfully. Math-based, Anti-Aim Analysis ~ Active.")
