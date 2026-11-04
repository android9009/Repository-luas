---@meta
-- neverlose CS:GO API — rage module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---The `rage` module exposes rage-bot related structs (`antiaim`, `exploit`).
---@class rage
---@field antiaim rage_antiaim Anti-aim controls.
---@field exploit rage_exploit Exploit (double-tap / defensive) controls.
rage = {}

---Anti-aim struct. Accessed via `rage.antiaim`.
---@class rage_antiaim
local rage_antiaim = {}

---Returns the maximum amount of desync.
---@return number
function rage_antiaim:get_max_desync() end

---Returns the current anti-aim rotation.
---@param value boolean? Optional. If `true`, fake rotation will be returned.
---@return number
function rage_antiaim:get_rotation(value) end

---Returns the at target yaw rotation or nil if not available.
---@param return_fr boolean? Optional. If `true`, freestanding yaw will be returned.
---@return number
function rage_antiaim:get_target(return_fr) end

---Gets or sets the state of the anti-aim inverter.
---@param value boolean? Optional. Inverter state.
---@return boolean
function rage_antiaim:inverter(value) end

---Overrides the hidden pitch to the desired value.
---@param value number Hidden pitch value.
---@return number
function rage_antiaim:override_hidden_pitch(value) end

---Overrides the hidden yaw offset to the desired value.
---@param value number Hidden yaw offset value.
---@return number
function rage_antiaim:override_hidden_yaw_offset(value) end

---Exploit struct. Accessed via `rage.exploit`.
---@class rage_exploit
local rage_exploit = {}

---Returns the exploit charge as a unit interval (value in the range [0, 1]).
---@return number
function rage_exploit:get() end

---Allows/blocks exploit charge.
---@param value boolean? Optional. If `true`, allows exploit charge. If `false`, blocks exploit charge. Defaults to `true`.
function rage_exploit:allow_charge(value) end

---Allows/blocks defensive exploit discharge.
---@param value boolean? Optional. If `true`, allows the cheat to discharge defensive exploit. If `false`, blocks defensive exploit discharge. Defaults to `true`.
function rage_exploit:allow_defensive(value) end

---Forces a teleport.
function rage_exploit:force_teleport() end

---Forces the exploit charge.
function rage_exploit:force_charge() end
