---@meta
-- neverlose CS:GO API — cvar module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---A ConVar/Command object. Obtained by indexing the `cvar` table with a
---ConVar or ConCommand name, e.g. `cvar.sv_cheats` or `cvar.clear`.
---@class cvar_object
local cvar_object = {}

---Executes a ConCommand or cvar callback, passing its arguments to it.
---@param ... any Arguments passed to the callback
function cvar_object:call(...) end

---Gets or sets the ConVar int value.
---When called without arguments, returns the current int value.
---When called with a value, sets the ConVar int value.
---@param value number New int value
---@param raw boolean? Optional. If `true` then the `raw` value will be set
---@overload fun(self: cvar_object): number
function cvar_object:int(value, raw) end

---Gets or sets the ConVar float value.
---When called without arguments, returns the current float value.
---When called with a value, sets the ConVar float value.
---@param value number New float value
---@param raw boolean? Optional. If `true` then the `raw` value will be set
---@overload fun(self: cvar_object): number
function cvar_object:float(value, raw) end

---Gets or sets the ConVar string value.
---@param value any? New string value. If not specified then returns the string value of the ConVar
---@return string
function cvar_object:string(value) end

---Registers the callback to the specified ConVar/Command. The registered
---function will be called every time the specified convar value is updated.
---
---For a ConVar, you can access the `cvar_object`, `old_value` and `new_value`
---by adding them to the function arguments.
---For a Command, you can access the `cvar_object` and `args` by adding them to
---the function arguments. Inside the callback, return false to prevent the
---command from being executed.
---@param callback function Lua function to call
function cvar_object:set_callback(callback) end

---Unregisters the callback that was set via the `:set_callback` function from
---the specified ConVar/Command.
---@param callback function Lua function that was passed to the `:set_callback` function
function cvar_object:unset_callback(callback) end

---The `cvar` table. Index it with a ConVar or ConCommand name to obtain a
---`cvar_object`, e.g. `cvar.sv_cheats` or `cvar.clear`.
---@type table<string, cvar_object>
cvar = {}
