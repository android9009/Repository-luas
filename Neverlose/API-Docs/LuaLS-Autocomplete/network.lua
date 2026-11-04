---@meta
-- neverlose CS:GO API — network module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

network = {}

---Sends a GET request to the URL.
---@param url string URL
---@param headers table? Headers. Optional.
---@param callback fun(response: string)? Callback. Optional.
---@return string
---@overload fun(url: string, callback: fun(response: string)): string
function network.get(url, headers, callback) end

---Sends a POST request to the URL.
---@param url string URL
---@param data table? Post data. Optional.
---@param headers table? Headers. Optional.
---@param callback fun(response: string)? Callback. Optional.
---@return string
---@overload fun(url: string, data: table, callback: fun(response: string)): string
function network.post(url, data, headers, callback) end
