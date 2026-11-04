---@meta
-- neverlose CS:GO API — materials module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

--#region Struct

---Material object returned by the materials module.
---@class Material
local Material = {}

---Returns the name of the material.
---@return string
function Material:get_name() end

---Returns the texture group name of the material.
---@return string
function Material:get_texture_group_name() end

---Gets or sets the value of the material var flag.
---@param flag number Material var flag
---@param value boolean? New material var flag value. Optional; when omitted the current value is returned.
---@return boolean
function Material:var_flag(flag, value) end

---Gets or sets the value of the material shader parameter.
---@param name string Shader parameter name
---@param value any? New shader parameter value. Optional; when omitted the current value is returned.
---@return any
function Material:shader_param(name, value) end

---Gets or sets the material color modulation value.
---@param color color? New color modulation value. Optional; when omitted the current value is returned.
---@return color
function Material:color_modulate(color) end

---Gets or sets the material alpha modulation value.
---@param alpha number? New alpha modulation value. Optional; when omitted the current value is returned.
---@return number
function Material:alpha_modulate(alpha) end

---Returns `true` if the material is valid.
---@return boolean
function Material:is_valid() end

---Resets the material properties to its original values along with discarding the override.
function Material:reset() end

---Overrides material properties to properties from another material without setting them.
---@param mat Material Material object with the needed properties
function Material:override(mat) end

--#endregion

--#region Functions

---Returns the material object in the specified path.
---@param path string Directory to the specified material
---@param force_load boolean? Loads the material if not loaded. Optional.
---@return Material
function materials.get(path, force_load) end

---If the callback is nil, it returns the table of material objects along the specified path.
---Otherwise the callback will be called. Access the material object using the arguments of the
---specified callback.
---@param partial_path string Directory to the specified materials
---@param force_load boolean? Loads each material if not loaded. Optional.
---@param callback fun(material: Material)? A callback with a pointer to the material object as the argument. Optional.
---@return Material[]
function materials.get_materials(partial_path, force_load, callback) end

---Creates and returns a new material object.
---@param name string New material name
---@param key_values string New material values
---@return Material
function materials.create(name, key_values) end

--#endregion
