-- neverlose library: md5 — MD5 hashing (one-shot and incremental).
-- Usage: local md5 = require("neverlose/md5")
-- LSP definition stub: neverlose loads the real library at runtime; this only provides types.

local md5 = {}

---Incremental MD5 hashing context returned by `md5.new()`.
---@class MD5Ctx
local MD5Ctx = {}

---Feeds more bytes into the running hash. Returns itself so calls can be chained.
---@param bytes string Bytes to add
---@return MD5Ctx self
function MD5Ctx:update(bytes) return self end

---Finalizes the hash and returns the raw MD5 digest (pass to `md5.tohex` for a hex string).
---@return string digest Raw MD5 bytes
function MD5Ctx:finish() return "" end

---Returns the raw MD5 digest of the message (16 raw bytes).
---@param message string Message to hash
---@return string digest Raw MD5 bytes
function md5.sum(message) return "" end

---Returns the MD5 digest of the message as a hex string.
---@param message string Message to hash
---@return string hex Lowercase hex string
function md5.sumhexa(message) return "" end

---Converts a raw MD5 digest (from `md5.sum`) to a hex string.
---@param digest string Raw MD5 bytes
---@return string hex Lowercase hex string
function md5.tohex(digest) return "" end

---Creates a new incremental MD5 hasher. Feed it with `:update` and finalize with `:finish`.
---@return MD5Ctx
function md5.new() return MD5Ctx end

return md5
