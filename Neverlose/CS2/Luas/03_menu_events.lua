-- @author Example
-- @uid 1
-- Read-only menu event logging. Does not require Allow Insecure.

events.on("menu_toggled", function(open)
    print(open and "Menu opened" or "Menu closed")
end)
