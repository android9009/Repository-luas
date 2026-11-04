---@meta
-- neverlose CS:GO API — files module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

files = {}

---Creates a new folder at the specified path.
---@param path string New folder path
function files.create_folder(path) end

---Returns contents of the specified file.
---@param path string Path to the file
---@return any
function files.read(path) end

---Replaces contents of the specified file. Returns `false` on failure.
---@param path string Path to the file
---@param contents any Contents the file should be set to
---@param is_binary boolean? Is `contents` a binary
---@return boolean
function files.write(path, contents, is_binary) end

---Returns the crc32 checksum of the file.
---@param path string Path to the file
---@return number
function files.get_crc32(path) end
