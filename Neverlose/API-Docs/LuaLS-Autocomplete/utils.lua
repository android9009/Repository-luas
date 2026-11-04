---@meta
-- neverlose CS:GO API — utils module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

utils = {}

---Executes a console command. Multiple commands can be combined with ';'.
---Be careful when passing user input (including usernames) to it.
---@param cmd string The console command(s) to execute
---@param ... any Comma-separated arguments to concatenate with cmd
function utils.console_exec(cmd, ...) end

---Executes the callback after delay seconds, passing the arguments to it.
---@param delay number Time in seconds to wait before calling callback
---@param callback fun(...) The Lua function that will be called after the delay
---@param ... any Arguments that will be passed to the callback
function utils.execute_after(delay, callback, ...) end

---Returns the `NetChannel` struct.
---@return NetChannel
function utils.net_channel() end

---Returns a `trace` struct containing all the information.
---The `skip` argument can either be an `entity` object, a table with `entity` objects, or a
---function, like the ShouldHitEntity callback. If you use it as a callback, you can access the
---`entity` and `contents_mask` by adding them to the function arguments. Inside the callback,
---return true if tracing should not skip the entity, otherwise return false.
---@param from vector Vector to start tracing from
---@param to vector Vector to trace to
---@param skip? entity|table|fun(entity: entity, contents_mask: number): boolean|nil Optional. Entity skipping options
---@param mask number? Optional. Trace mask
---@param type number? Optional. Trace type [0-3]: 0 everything [Default], 1 world only, 2 entities only, 3 everything filter props
---@return trace
function utils.trace_line(from, to, skip, mask, type) end

---Returns a `trace` struct containing all the information.
---The `skip` argument can either be an `entity` object, a table with `entity` objects, or a
---function, like the ShouldHitEntity callback. If you use it as a callback, you can access the
---`entity` and `contents_mask` by adding them to the function arguments. Inside the callback,
---return true if tracing should not skip the entity, otherwise return false.
---@param from vector Vector to start tracing from
---@param to vector Vector to trace to
---@param mins vector Hull mins
---@param maxs vector Hull maxs
---@param skip? entity|table|fun(entity: entity, contents_mask: number): boolean|nil Optional. Entity skipping options
---@param mask number? Optional. Trace mask
---@param type number? Optional. Trace type [0-3]: 0 everything [Default], 1 world only, 2 entities only, 3 everything filter props
---@return trace
function utils.trace_hull(from, to, mins, maxs, skip, mask, type) end

---Returns the `damage`, `trace` arguments.
---The `skip` argument can either be an `entity` object, a table with `entity` objects, or a
---function, like the ShouldHitEntity callback. If you use it as a callback, you can access the
---`entity` and `contents_mask` by adding them to the function arguments. Inside the callback,
---return true if tracing should not skip the entity, otherwise return false.
---@param from_entity entity Player whose weapon will be used for this trace
---@param from vector Vector to start tracing from
---@param to vector Vector to trace to
---@param skip? entity|table|fun(entity: entity, contents_mask: number): boolean|nil Optional. Entity skipping options. If not passed, the skip entity will be from_entity
---@return number damage
---@return trace trace
function utils.trace_bullet(from_entity, from, to, skip) end

---Returns a pointer to the specified pattern if it was found. Otherwise returns `nil`.
---@param module string Module name, in which the signature will be scanned.
---@param signature string IDA style signature, the wildcard is "?"
---@param offset number? Optional offset to apply to the pointer address.
---@return userdata?
function utils.opcode_scan(module, signature, offset) end

---Returns a pointer to the specified interface if it was found. Otherwise returns `nil`.
---@param module string Module name containing the interface.
---@param interface string Interface name.
---@return userdata?
function utils.create_interface(module, interface) end

---Returns the offset of the specified prop. Can be used to manually navigate to the net prop.
---@param table string Datatable name
---@param prop string Prop name
---@return number
function utils.get_netvar_offset(table, prop) end

---Creates and returns a wrapper function that calls a virtual table function on the specified index.
---@param index number Virtual table index of the function.
---@param ... any FFI C Type definition.
---@return function
---@overload fun(module: string, interface: string, index: number, ...): function
function utils.get_vfunc(index, ...) end

---Returns a random integer value.
---@param min number Minimum boundary for the random value, included
---@param max number Maximum boundary for the random value, included
---@return number
function utils.random_int(min, max) end

---Returns a random float value.
---@param min number Minimum boundary for the random value, included
---@param max number Maximum boundary for the random value, included
---@return number
function utils.random_float(min, max) end

---Sets the new random seed.
---@param seed number New random seed value
function utils.random_seed(seed) end

---A trace result struct returned by `utils.trace_line`, `utils.trace_hull` and `utils.trace_bullet`.
---@class trace
---Start position.
---@field start_pos vector
---Final position.
---@field end_pos vector
---Surface normal at impact. Contains `normal`, `dist`, `type`, and `signbits` values.
---@field plane table
---Percentage in the range [0.0, 1.0]. How far the trace went before hitting something. 1.0 - didn't hit anything.
---@field fraction number
---Contents on other side of surface hit.
---@field contents number
---Displacement flags for marking surfaces with data.
---@field disp_flags number
---Returns `true` if the plane is invalid.
---@field all_solid boolean
---Returns `true` if the initial point was in a solid area.
---@field start_solid boolean
---Percentage in the range [0.0, 1.0]. How far the trace went before leaving solid. Only valid if we started in solid.
---@field fraction_left_solid number
---Surface hit (impact surface). Contains `name`, `props`, and `flags` values.
---@field surface table
---0 - generic, non-zero is specific body part.
---@field hitgroup number
---Physics bone that was hit by the trace.
---@field physics_bone number
---Index of the msurface2_t, if applicable.
---@field world_surface_index number
---Entity that was hit by the trace.
---@field entity entity
---Box that was hit by the trace.
---@field hitbox number
---Returns `true` if there was any kind of impact at all.
---@field did_hit fun(self: trace): boolean
---Returns `true` if the `entity` points at the world entity.
---@field did_hit_world fun(self: trace): boolean
---Returns `true` if the trace hit something and it wasn't the world.
---@field did_hit_non_world fun(self: trace): boolean
---Returns `true` if the final position is visible.
---@field is_visible fun(self: trace): boolean
local trace = {}

---The `NetChannel` struct, accessed via `utils.net_channel()`.
---Flow values: `FLOW:OUTGOING = 0`, `FLOW:INCOMING = 1`.
---@class NetChannel
---Current network time.
---@field time number
---Connection time in seconds.
---@field time_connected number
---Time since last received packet in seconds.
---@field time_since_last_received number
---Returns `true` if server is a loopback (local server).
---@field is_loopback boolean
---Returns `true` if demo is being played.
---@field is_playback boolean
---Returns `true` if client is timing out.
---@field is_timing_out boolean
---Last sent sequence number, indexed by flow (0 outgoing, 1 incoming).
---@field sequence_nr number[]
---Current latency (RTT), more accurate but jittering, indexed by flow (0 outgoing, 1 incoming).
---@field latency number[]
---Average latency in seconds, indexed by flow (0 outgoing, 1 incoming).
---@field avg_latency number[]
---Percentage in the range [0.0, 1.0] of the current packet loss, indexed by flow (0 outgoing, 1 incoming).
---@field loss number[]
---Percentage in the range [0.0, 1.0] of the current packet choke, indexed by flow (0 outgoing, 1 incoming).
---@field choke number[]
---Average amount of packets/sec, indexed by flow (0 outgoing, 1 incoming).
---@field packets number[]
---Data flow in bytes/sec, indexed by flow (0 outgoing, 1 incoming).
---@field data number[]
---Total amount of packets/sec, indexed by flow (0 outgoing, 1 incoming).
---@field total_packets number[]
---Total data flow in bytes/sec, indexed by flow (0 outgoing, 1 incoming).
---@field total_data number[]
local NetChannel = {}

---Returns a table containing `rate`, `name`, `address`, `frame_time`, and `deviation`
---(or nil on failure).
---@return table?
function NetChannel:get_server_info() end

---Returns `true` if the packet is valid.
---@param flow number Channel (Flow)
---@param frame number Sequence number
---@return number
function NetChannel:is_valid_packet(flow, frame) end

---Returns the time when the packet was sent.
---@param flow number Channel (Flow)
---@param frame number Sequence number
---@return number
function NetChannel:get_packet_time(flow, frame) end

---Returns the group size of this packet.
---@param flow number Channel (Flow)
---@param frame number Sequence number
---@param group number Group of this packet
---@return number
function NetChannel:get_packet_bytes(flow, frame, group) end

---Returns `latency_msecs`, `choke` of this packet.
---@param flow number Channel (Flow)
---@param frame number Sequence number
---@return number latency_msecs
---@return number choke
function NetChannel:get_packet_response_latency(flow, frame) end
