---@meta
-- neverlose CS:GO API — _G (global free functions/values). Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---If the result of the first argument is false or nil, an error is thrown with the second argument as the message.
---@param expression any The expression to assert.
---@param text string? The error message to throw when assertion fails. This is only type-checked if the assertion fails.
---@param ... any Any arguments past the error message will be returned by a successful assert.
---@return any
function assert(expression, text, ...) end

---Throws a Lua error and breaks out of the current call stack.
---@param text any The error message to throw.
---@param level number? The level to throw the error at.
function error(text, level) end

---Returns the metatable of an object. This function obeys the metatable's `__metatable` field, and will return that field if the metatable has it set.
---@param object any The value to return the metatable of.
---@return any
function getmetatable(object) end

---Returns an iterator function for a for loop, to return ordered key-value pairs from a table.
---@param tbl table The table to iterate over.
---@return function
---@return table
---@return number
function ipairs(tbl) end

---Prints the text to the console.
---@param text string Text to print into the console.
---@param ... any Optional arguments to concatenate with `text`.
function print(text, ...) end

---Prints an error to the console and plays a sound.
---@param text string Text to print into the console.
---@param ... any Optional arguments to concatenate with `text`.
function print_error(text, ...) end

---Prints the text to the in-game chat.
---@param text string Text to print into the in-game chat.
---@param ... any Optional arguments to concatenate with `text`.
function print_chat(text, ...) end

---Prints the text that can be changed in color by prepending it with `"\a"` followed by the color in the hexadecimal "RRGGBB" format. For example, `"\aFF0000Hi"` will print `"Hi"` in red.
---@param text string Text to print into the console.
---@param ... any Optional arguments to concatenate with `text`.
function print_raw(text, ...) end

---Prints the text into the upper-left console panel.
---@param text string Text to print to into the upper-left console panel.
---@param ... any Optional arguments to concatenate with `text`.
function print_dev(text, ...) end

---Returns the numeric representation of the value with the given base, or `nil` if the conversion failed.
---@param value any The value to convert. Can be a number or string.
---@param base number? Optional. The base used in the string. Can be any integer between 2 and 36, inclusive.
---@return number?
function tonumber(value, base) end

---Returns the string representation of the value.
---@param var any The object to be converted to a string.
---@return string
function tostring(var) end

---Returns the name of the object's type.
---@param var any The object to get the type of.
---@return string
function type(var) end

---Returns a vararg of the table's values, optionally between a start and end index.
---@param tbl table The table to generate the vararg from.
---@param start_index number? Which index to start from. Optional.
---@param end_index number? Which index to end at. Optional, even if you set `start_index`.
---@return ...
function unpack(tbl, start_index, end_index) end

---Attempts to call the first function. If the execution succeeds, this returns `true` followed by the returns of the function. If execution fails, this returns `false` and the second function is called with the error message.
---@param func function The function to call initially.
---@param err_callback function The function to be called if execution of the first fails. The error message is passed as a string.
---@param ... any Arguments to pass to the initial function.
---@return boolean
---@return ...
function xpcall(func, err_callback, ...) end

---Converts time (seconds) to ticks.
---@param time number The seconds to convert to ticks.
---@return number
function to_ticks(time) end

---Converts ticks to time (seconds).
---@param ticks number The number of ticks to convert to time.
---@return number
function to_time(ticks) end

---A class created by `new_class()`. Define structs on it with the call-syntax
---builder `:struct 'name' { ... }` (chainable), then access each struct by name:
---
---```lua
---local ctx = new_class()
---    :struct 'struct_one' {
---        variable1 = 'test',
---        some_function = function(self, arg1) print(self.variable1, arg1) end,
---    }
---ctx.struct_one:some_function('test')
---```
---@class NLClass
---Access a defined struct by its name (also how sibling structs reach each other via `self`).
---@field [string] any
local NLClass = {}

---Defines a struct on the class. Use Lua's call syntax:
---`:struct 'name' { field = value, method = function(self, ...) ... end }`.
---Returns a function that takes the struct definition table and returns the class,
---so multiple `:struct` calls can be chained.
---@param name string Name of the struct (later accessed as `class.<name>`)
---@return fun(definition: table): NLClass
function NLClass:struct(name) end

---Creates a new class. This class system makes it easier to structure code in complex projects.
---@return NLClass
function new_class() end
