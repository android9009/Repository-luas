---@meta
-- neverlose CS:GO API — vector module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---A 3D vector object. All vectors are 3D, even the ones you'd expect to be 2D.
---Angles are also represented as 3D vectors (x is pitch, y is yaw, z is roll).
---The x, y, and z coordinates can be read and written directly.
---@class vector
---@field x number X coordinate
---@field y number Y coordinate
---@field z number Z coordinate
---@operator add(vector|number): vector
---@operator sub(vector|number): vector
---@operator mul(vector|number): vector
---@operator div(vector|number): vector
---@operator unm: vector
vector = {}

---Converts the angle into a forward vector overwriting the vector's coordinates. Returns itself.
---@param pitch number Pitch component of the angle
---@param yaw number Yaw component of the angle
---@return vector
---@overload fun(self: vector, angle: vector): vector
---@overload fun(self: vector): vector
function vector:angles(pitch, yaw) end

---Ceils & overwrites the x, y, and z coordinates of a vector. Returns itself.
---@return vector
function vector:ceil() end

---Creates and returns a copy of the vector.
---@return vector
function vector:clone() end

---Returns the vector of the closest point along a ray.
---@param ray_start vector Ray start position
---@param ray_end vector Ray end position
---@return vector
function vector:closest_ray_point(ray_start, ray_end) end

---Returns the cross product of two given vectors.
---@param other vector The vector to calculate the cross product with
---@return vector
function vector:cross(other) end

---Returns the Euclidean distance between the two given vectors.
---@param other vector The vector to get the distance to
---@return number
function vector:dist(other) end

---Returns the 2D distance to another vector.
---@param other vector The vector to get the distance to
---@return number
function vector:dist2d(other) end

---Returns the squared 2D distance to another vector.
---@param other vector The vector to get the squared distance to
---@return number
function vector:dist2dsqr(other) end

---Returns the squared Euclidean distance to another vector.
---@param other vector The vector to get the squared distance to
---@return number
function vector:distsqr(other) end

---Returns the distance to a ray.
---@param ray_start vector Ray start position
---@param ray_direction vector Ray direction
---@return number
function vector:dist_to_ray(ray_start, ray_direction) end

---Returns the dot product of the two given vectors.
---@param other vector The vector to calculate the dot product with
---@return number
function vector:dot(other) end

---Rounds the x, y, and z coordinates of the vector down to the largest integer that is less than or equal. Returns itself.
---@return vector
function vector:floor() end

---Returns true if the vector is within the given distance to another vector.
---@param other vector The vector to calculate the distance to
---@param range number The distance
---@return boolean
function vector:in_range(other, range) end

---Overwrites the vector's coordinates. Returns itself.
---@param x number New X coordinate
---@param y number New Y coordinate
---@param z number New Z coordinate
---@return vector
function vector:init(x, y, z) end

---Returns the Euclidean length of the vector.
---@return number
function vector:length() end

---Returns the length of the vector in two dimensions, without the Z axis.
---@return number
function vector:length2d() end

---Returns the squared length of the vectors x and y value.
---@return number
function vector:length2dsqr() end

---Returns the squared length of the vector.
---@return number
function vector:lengthsqr() end

---Returns the linearly interpolated vector between two vectors by the specified weight.
---@param other vector The vector to interpolate to
---@param weight number A value between 0 and 1 that indicates the weight of other
---@return vector
function vector:lerp(other, weight) end

---Normalizes the vector and returns the length of the vector.
---@return number
function vector:normalize() end

---Returns a vector with the same direction as the specified vector, but with a length of one.
---@return vector
function vector:normalized() end

---Multiplies the vector by the specified scalar.
---@param scalar number The scalar value
---@return vector
function vector:scale(scalar) end

---Returns a copy of the vector multiplied by the specified scalar.
---@param scalar number The scalar value.
---@return vector
function vector:scaled(scalar) end

---Returns the forward vector from itself to another vector.
---@param other vector The vector to get the direction to.
---@return vector
function vector:to(other) end

---Returns a vector containing the coordinates where the specified position vector appears on the screen.
---@return vector
function vector:to_screen() end

---Returns the x, y, and z coordinates of the vector. Note that these fields can be accessed by indexing x, y, and z.
---@return number x
---@return number y
---@return number z
function vector:unpack() end

---Returns the right and up vector of a forward vector.
---@return vector right
---@return vector up
function vector:vectors() end

---Creates a new vector object. All vectors are 3D.
---Missing components default to 0.
---@param x number? X coordinate. Optional.
---@param y number? Y coordinate. Optional.
---@param z number? Z coordinate. Optional.
---@return vector
---@overload fun(): vector
---@overload fun(x: number): vector
---@overload fun(x: number, y: number): vector
function vector(x, y, z) end
