---@meta
-- neverlose CS:GO API — db module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---The `db` persistent-storage table. Index it with a key name to read the
---stored value, and assign to a key name to persist a value.
---
---`db.key_name` returns the stored value (`any`), or `nil` if the key does not
---exist. `db.key_name = value` stores the value. The value can be anything that
---can be sanitized (no functions, userdata).
---
---Warning: Indexing database keys is a heavy process. Do not do it inside
---callbacks that are called a lot of times per second.
---@type table<any, any>
db = {}
