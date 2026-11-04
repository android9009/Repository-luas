-- @author Example
-- @uid 1
-- Prints load/unload messages. Does not require Allow Insecure.

print("Hello from Neverlose Lua!")

events.on("unload", function()
    print("Hello World unloaded")
end)
