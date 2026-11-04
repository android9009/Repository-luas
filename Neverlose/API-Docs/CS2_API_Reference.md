# Neverlose Lua API — справочник

Основа этого справочника — переданная владельцем проекта восстановленная
спецификация Lua API. Сигнатуры, ограничения и отметки неопределённости сохранены.
Это документация данной сборки, отдельная от документации сторонних продуктов.

- Рантайм из спецификации: **LuaJIT 2.1 / Lua 5.1**.
- `wl.*` — реальные внутренние имена типов, их не нужно переименовывать в скриптах.
- `x?` означает необязательный аргумент. Пометка `(?)` означает, что назначение
  аргумента или возвращаемого значения не установлено полностью.
- Адреса `@0x…` и приложения A/B относятся к исходному бинарнику из спецификации.
  Они приведены для исследования и не являются стабильными адресами текущих сборок.
- Примеры в репозитории ещё не проверены запуском внутри игры.

[Главная](../README.md) · [Быстрый старт](getting-started.md) · [Примеры](../examples/README.md)

## Содержание

- [Окружение](#environment)
- [События](#events)
- [Векторы, цвета, math, JSON и db](#types)
- [Игроки и объекты](#entity)
- [Отрисовка и ресурсы](#render)
- [Трассировки](#trace)
- [Меню](#ui)
- [engine, globals, input и game](#engine)
- [client, user, config и другие модули](#client)
- [Команды](#cmd)
- [Камера](#view)
- [Объекты игровых событий](#event)
- [Частицы](#particle)
- [Расширения ESP](#esp)
- [Утилиты](#utils)
- [Insecure API](#insecure)
- [Справочные адреса](#addresses)
- [Встроенный Lua-код](#embedded)

---

<a id="environment"></a>

## 0. Окружение и песочница

| Что | Статус |
|---|---|
| Стандартные библиотеки | `_G` (base), `table`, `string`, `math`, `bit`, `jit` |
| `ffi` | **только** при включённом *allow insecure* (страница lua) |
| `io`, `debug`, `package` | не загружаются |
| `dofile`, `loadfile` | `nil` |
| `load`, `loadstring` | заменены своей реализацией `@0x18006EC70` |
| `require` | своя реализация `@0x18006E7B0`, кэш в `REGISTRY.wl_modules` |
| `os` | урезан: `os.clock()` (= `globals.realtime`), `os.time()`, `os.date()` |
| `print(...)` | `@0x18004ED60`, через `tostring`, пишет в вывод Lua |

Папки на диске:

- `C:\neverwin\scripts\images\` — `render.load_image`, `render.load_svg`
- `C:\neverwin\scripts\fonts` (+ `Windows\Fonts`) — `render.font`
- `C:\neverwin\scripts\particles` — `particle.override`
- `C:\neverwin\scripts\data` — `file.*`; `data\db\<name>.json` — `db.*`

Некоторые функции работают только в определённом контексте:

- `render.*` (рисование): только внутри `paint`, иначе ошибка *"render.\* draws only inside a paint callback"*.
- `trace.*`, `engine.simulate`: только в `createmove`, `frame_stage` и колбэках игровых событий.
- `wl.cmd`: только внутри своего `createmove`. `wl.view`: только внутри `override_view`. `wl.event`: только внутри своего колбэка.

---

<a id="events"></a>

## 1. События — `events`

```lua
id = events.on(name: string, fn: function) -> integer   -- @0x18004EE00 (luaL_ref колбэка)
ok = events.off(id: integer) -> boolean                   -- @0x18004F020
```

| Событие | Аргументы колбэка | Где диспатчится |
|---|---|---|
| `paint` | — | `@0x180074880` |
| `createmove` | `cmd: wl.cmd` | `@0x180074460` |
| `frame_stage` | `stage: integer` (см. `stage.*`) | `@0x180074270` |
| `override_view` | `view: wl.view` | `@0x180075040` |
| `menu_toggled` | `open: boolean` | `@0x180074690` |
| `level_init` | `map: string` | `@0x180074A50` |
| `level_shutdown` | — | `@0x180074C50` |
| `movement_hit` | `string, number, number` *(смысл не установлен)* | `@0x180074E20` |
| `player_esp` | `player: wl.entity, box: {left, top, right, bottom}` | `@0x180075270` |
| `unload` | — | `@0x18006E200` |
| *любое игровое событие* (`player_hurt`, `player_death`, …) | `ev: wl.event` | `@0x180073DF0` |

---

<a id="types"></a>

## 2. Встроенные Lua-типы (прелюдия)

### `vector(x?, y?, z?)` → vector
Таблица `{x, y, z}` (по умолчанию 0). Перегружены операторы `+ - * /` (с вектором или числом), унарный `-`, `==`, `tostring`.

| Метод | Описание |
|---|---|
| `:length()` / `:length_sqr()` / `:length2d()` | длина |
| `:dist(o)` / `:dist2d(o)` | расстояние |
| `:dot(o)` / `:cross(o)` | скалярное / векторное произведение |
| `:normalized()` / `:clone()` / `:unpack()` / `:is_zero()` | |
| `:lerp(o, t)` | |
| `:forward()` | вектор направления из углов (pitch, yaw) |
| `:angle_vectors()` | → `forward, right, up` |
| `:angles()` | вектор направления → `vector(pitch, yaw, 0)` |

### `color(r?, g?, b?, a?)` / `color("#RRGGBB[AA]")` → color
Таблица `{r, g, b, a}`, значения 0..255, по умолчанию 255. `color(v)` даёт серый `(v, v, v)`.

| Метод | Описание |
|---|---|
| `:alpha(a)` | копия с другой альфой |
| `:lerp(o, t)` / `:unpack()` / `:hex()` | |
| `:hsv()` | → `h, s, v` (0..1) |
| `:darken(f=0.5)` / `:lighten(f=0.5)` / `:gray()` | |

Есть также `color_hsv(h, s, v, a?)` и `color_percent(p, a?)` (градиент красный→зелёный).

C-функции читают цвет из полей `r,g,b,a` (значения ограничиваются диапазоном 0..255, `a` по умолчанию 255). Если передать не таблицу, будет ошибка *"bad argument #N (a color is needed: color(r, g, b, a))"*.

### Расширения `math`
`math.clamp(v, lo, hi)`, `math.lerp(a, b, t)`, `math.round(v)`, `math.remap(v, a, b, c, d)`, `math.normalize_angle(a)`, `math.calc_angle(from, to)` (возвращает `(to-from):angles()`).

### `json`
`json.encode(v) -> string` (вложенность не больше 200), `json.decode(text) -> value | nil, err`, `json.null`.

### `db` (поверх `db._read`/`db._write`, после инициализации они обнуляются)
```lua
db.save(name, value) -> boolean      -- json.encode → C:\neverwin\scripts\data\db\<name>.json
db.load(name, default) -> value
```
В имени допустимы только буквы, цифры, `_` и `-`.

---

<a id="entity"></a>

## 3. `entity`

```lua
entity.local_pawn()        -> wl.entity | nil        -- @0x180050D50
entity.local_controller()  -> wl.entity | nil        -- @0x180050E00
entity.get(index: int)     -> wl.entity | nil        -- @0x180050E90
entity.from_handle(h: num) -> wl.entity | nil        -- @0x180050F80
entity.from_address(addr)  -> wl.entity              -- @0x1800A74D0
entity.players()           -> { {controller=wl.entity, pawn=wl.entity|nil}, ... }   -- @0x180051010
entity.all(class_name?: string) -> { wl.entity, ... } -- @0x180051160
```

### Объект `wl.entity`
| Метод | Возврат | Адрес |
|---|---|---|
| `:address()` | number | `@0x18004F680` |
| `:class_name()` | string | `@0x18004F6F0` |
| `:health()` / `:armor()` / `:team()` | integer | |
| `:alive()` | boolean | |
| `:name()` | string | |
| `:origin()` / `:velocity()` / `:eye_position()` / `:eye_angles()` / `:aim_punch()` | vector | |
| `:bone(index: int)` | vector \| nil | `@0x18004FF40` |
| `:pawn()` | wl.entity \| nil (контроллер → pawn) | |
| `:weapon()` | wl.entity \| nil (активное оружие) | |
| `:weapons()` | { wl.entity } (`m_hMyWeapons`) | `@0x1800783E0` |
| `:is_enemy()` / `:is_local()` | boolean | |
| `:steam_id()` | string (`%llu`) \| nil | |
| `:ping()` / `:money()` | integer \| nil | |
| `:observer_target()` | wl.entity \| nil | |
| `:bbox()` | `left, top, right, bottom` на экране \| nil | `@0x18005EE60` |
| `:flags()` | integer (`m_fFlags`) | |
| `:on_ground()` / `:scoped()` | boolean | |
| `:hitbox(index: int)` | vector (центр) \| nil | `@0x180079210` |
| `:hitboxes()` | `{ {index, group, group_name, radius, bone, shape, translation_only, center, mins, maxs}, ... }` | `@0x180078D00` |
| `:weapon_info()` | `{def, name, display, type, gun, clip, reserve, max_clip, max_speed, full_auto, can_shoot, inaccuracy, spread, ...}` \| nil | `@0x1800785C0` |
| `:avatar(size?: int)` | wl.texture (1..512) | `@0x1800A7670` |
| `:get(class, field, type)` / `:get(offset, type)` | value | `@0x180050BF0` |
| `:set(class, field, type, value)` / `:set(offset, type, value)` | — (**insecure**) | `@0x180050C70` |
| `:vdata(field, type, class?="CCSWeaponBaseVData")` *(?)* | value | `@0x18005F0E0` |
| `==`, `tostring` → `"entity(<class>: <ptr>)"` | | |

Типы для `get`/`set`/`memory.*`: `int uint short byte int64 float double bool ptr vector handle string` (`string` только на чтение). Если поле не найдено: *"schema: no field %s::%s"*.

---

<a id="render"></a>

## 4. `render` (только в `paint`)

```lua
render.rect(x, y, w, h, color, rounding?, thickness?, corners?)      -- corners: int или строка
render.rect_filled(x, y, w, h, color, rounding?, corners?)
render.rect_filled_multicolor(x, y, w, h, c1, c2, c3, c4)
render.gradient(x, y, w, h, color1, color2, horizontal?: bool)
render.line(x1, y1, x2, y2, color, thickness?)
render.circle(x, y, radius, color, segments?, thickness?)
render.circle_filled(x, y, radius, color, segments?)
render.circle_gradient(x, y, radius, inner: color, outer: color, segments?)
render.triangle_filled(x1, y1, x2, y2, x3, y3, color)
render.triangle_multicolor(x1, y1, c1, x2, y2, c2, x3, y3, c3)
render.poly(points: {{x,y},...}, color, thickness?, closed?: bool)
render.poly_filled(points: {{x,y},...}, color)
render.pie(x, y, radius, fraction, color, segments?, start?)          -- (?)
render.arc(x, y, radius, start_deg, end_deg, color, thickness?, segments?)
render.shadow(x, y, w, h, color, thickness?, rounding?)
render.blur(x, y, w, h, strength?, tint?: color) -> boolean
render.text(x, y, color, text, flags?: string, size?: number, font?: wl.font)
render.image(texture, x, y, w?, h?, color?, rounding?)
render.clip_push(x, y, w, h, intersect?: bool)
render.clip_pop()
```

Эти функции можно вызывать вне `paint`:

```lua
render.text_size(text, flags?, size?, font?) -> w, h
render.wrap_text(text, max_width, size?, font?) -> { line, ... }
render.world_to_screen(v: vector) -> x, y | nil
render.screen_size() -> w, h
render.scale() -> number          -- DPI в долях (percent / 100)
render.menu_scale() -> number
render.theme(name?: string) -> color | { [name] = color, ... }
render.font(name: string, size?: number) -> wl.font               -- scripts\fonts или Windows\Fonts
render.load_image(file, w, h) -> wl.texture | nil, err             -- 1..4096, из scripts\images
render.load_svg(file, height) -> wl.texture | nil, err             -- 1..4096
render.texture(rgba: string, w, h) -> wl.texture                   -- len = 4*w*h, 1..2048
render.icon(name, height?) -> wl.texture | nil, "no such icon"     -- 1..256
render.icons() -> { name, ... }
```
Ограничение: не больше 256 текстур на скрипт.

- `wl.texture:size()` → `w, h`
- `wl.font:loaded()` → boolean

---

<a id="trace"></a>

## 5. `trace`
Работает только в `createmove`/`frame_stage`/игровых событиях (кроме `scale_damage`, `smoke`).

```lua
trace.line(from: vector, to: vector, opts?) -> result
trace.hull(from, to, mins: vector, maxs: vector, opts?) -> result
-- opts: wl.entity (skip) | { skip = wl.entity | {wl.entity,...}, mask = int, layer = int, type = int, mins = vector, maxs = vector }
-- result: { hit, fraction, position: vector, normal: vector, entity: wl.entity|nil, start_solid, friction, ... }

trace.bullet(from, to, target?: wl.entity, hitgroup?: int)
    -> { hit, entity, damage, penetrated, position, range, target_damage, target_hit }
trace.damage(target: wl.entity, pos: vector, hitgroup?: int, from?: vector) -> number
trace.can_penetrate(from, to) -> boolean
trace.scale_damage(damage: number, hitgroup: int, target: wl.entity) -> number
trace.smoke(from, to) -> boolean, number
```

Константы `trace.mask`: `visible = 1847299`, `shot = 1847307`, `player = 1839107`.

---

<a id="ui"></a>

## 6. `ui` (меню)
Все конструкторы работают и через точку, и через двоеточие (`ui.checkbox(...)` и `tab:checkbox(...)`). Если первым аргументом пришла таблица, она отбрасывается.

```lua
tab   = ui.tab(name: string, icon?: string|wl.texture) -> tab   -- до 64 вкладок на скрипт
group = tab:group(name)  /  ui.group(name)                       -- в tab и group есть те же конструкторы
ui.sidebar(name?, icon?)

ui.checkbox(name, default?: bool)                    -> wl.ui
ui.slider_int(name, min, max, default?, fmt="%d")    -> wl.ui
ui.slider_float(name, min, max, default?, fmt="%.2f")-> wl.ui
ui.combo(name, items: {string}, default_index?)      -> wl.ui
ui.multi_combo(name, items: {string}, defaults?: {bool|int}) -> wl.ui
ui.listbox(name, items, default?, height?)           -> wl.ui
ui.color(name, default?: color, alpha?: bool)        -> wl.ui
ui.button(name, callback?: function)                 -> wl.ui
ui.text(name, default?: string)                      -> wl.ui   -- поле ввода
ui.label(text)                                       -> wl.ui
ui.keybind(name, key?: int)                          -> wl.ui
ui.divider(text?)                                    -> wl.ui
ui.image(name, texture, height?)                     -> wl.ui
ui.custom(name, height, fn(x, y, w, h, input))       -> wl.ui
ui.widget(name, w, h, fn(x, y, w, h, input))         -> wl.ui
-- input: { hover, click, rclick, mx, my, hovered, active, down, clicked, released,
--          right_down, right_clicked, dragging, x, y, wheel }

ui.find(page, group, ...name) -> wl.menu_control | group   -- элементы основного меню
ui.binds(active_only?: bool) -> { {name, mode, value, reference: wl.menu_control, is_active}, ... }
ui.beta_exploits(enable?) -> boolean
ui.alpha() -> number
ui.scale(name_or_value, ...) -> number
ui.position() / ui.size() -> vector
ui.cursor() -> vector
ui.style(key?) -> value | table
ui.localize(lang, key, text)
ui.units(value?) -> string | number, string    -- "metric"/"imperial", "m"/"ft"
```

### Объект `wl.ui` (элемент, созданный скриптом)
| Метод | Описание |
|---|---|
| `:get(index?)` | значение: bool / int / number / string / `{[item]=bool}` / color |
| `:set(value, ...)` | |
| `:visible(bool?)` | геттер или сеттер |
| `:depends(other: wl.ui, value?)` | показывать только при условии, возвращает self |
| `:callback(fn)` | возвращает self |
| `:items(list)` | только для combo и listbox |
| `:active()` | только для keybind |
| `:name()` | |
| `:tooltip(text?)` | возвращает self |
| `:inactive(bool, reason?)` | возвращает self |
| `:image(texture)` | возвращает self |
| `:position()` | `x, y` |
| `:set_position(x, y)` | возвращает self |

### Объект `wl.menu_control` (элемент основного меню, из `ui.find`)
`get`, `get_value`, `set_value`, `get_raw_value`, `set_raw_value`, `get_values`, `set_values`, `get_raw_values`, `set_raw_values`, `get_effective_values` (`*_values` только для multi-select), `get_default`, `set_default`, `get_name`, `get_visible`, `set_visible(b)`, `get_disabled`, `set_disabled(b)`, `get_tooltip`, `get_icon`, `get_id`, `get_type` (`"toggle"|"slider"|"combo"|"multicombo"|"unknown"`), `get_is_down`, `get_parent`, `get_items`, `get_min`, `set_min(v)`, `get_max`, `set_max(v)`, `export()` → JSON-строка, `group()`, `add_callback(fn)`, `remove_callback(fn)`, `==`, `tostring`.

Эти методы существуют, но для встроенных элементов только бросают ошибку (*"script does not own this element"*, *"option is not a color picker"*, *"chips can only be added to entity elements"*): `set_name`, `set_icon`, `import`, `color_picker`, `color_set`, `color_modes`, `set_tooltip`, `set_items`, `get_category`, `set_category`, `get_categories`, `chip`.

---

<a id="engine"></a>

## 7. `engine`, `globals`, `input`, `game`

```lua
engine.exec(cmd: string)
engine.in_game() -> boolean
engine.screen_size() -> w, h
engine.play_sound(name)                 -- через panorama $.PlaySoundEvent
engine.view_angles() -> vector
engine.set_view_angles(v: vector) -> boolean
engine.camera_angles() -> vector
engine.max_speed() -> number
engine.post_state() -> { valid, status, flags, on_ground, move_type, landed_frac, landed, tick, origin, velocity, ... }
engine.simulate(ticks: int, fn?: function) -> { {valid, flags, on_ground, move_type, jumped, landed, landed_frac, duck, origin, velocity}, ... }
                                        -- только в createmove

globals.curtime() / realtime() / frametime() -> number
globals.interval() -> 0.015625
globals.tickcount() / framecount() -> integer

input.key_down(vk) -> boolean
input.key_pressed(vk) -> boolean
input.key_name(vk) -> string | nil
input.cursor() -> x, y
input.menu_open() -> boolean

game.map() -> string
game.in_menu() / warmup() / freeze_time() / bomb_planted() / match_started() -> boolean
game.rounds_played() -> integer
game.round_time_left() -> number
```

---

<a id="client"></a>

## 8. `client`, `user`, `log`, `config`, `binds`, `cvar`, `schema`, `panorama`

```lua
client.delay(seconds, fn)
client.unload() / client.reload()
client.name() -> string                 -- имя скрипта
client.insecure() -> boolean
client.notify(text, title?)
client.owner() -> { name, uid, mine, since, loaded_by, loaded_uid }

user.name() -> string
user.uid() -> integer
user.info() -> { name, uid }
user.avatar(size?) -> wl.texture        -- 1..512

log.chat(...)    log.console(...)       -- через tostring, с префиксом "[script] "

config.get(path) -> bool | int | number | string | { ... }
config.set(path, value: bool|number|string|list) -> boolean
config.keys(prefix?) -> { path, ... }

binds.list() -> { {field, key, key_name, mode, value, number, active}, ... }
binds.add(field, key: int, mode?: "hold"|"toggle"|"always", value?) -> true
binds.remove(field, key?)
binds.active(field, key?) -> boolean

cvar.find(name) -> wl.cvar | nil
schema.offset(class, field) -> integer
panorama.run(js: string, context?: "hud"|"menu")
```

`wl.cvar`: `get_int`, `get_float`, `get_bool`, `set_int(v)`, `set_float(v)`, `set_bool(v)`, `restore()`, `name()`.

---

<a id="cmd"></a>

## 9. `wl.cmd` (аргумент `createmove`)
| Метод | |
|---|---|
| `:number()` / `:tick()` | номер команды / тик |
| `:buttons()` / `:set_buttons(mask)` | |
| `:has(btn)` / `:press(btn)` / `:release(btn)` | |
| `:move()` → `forward, side` / `:set_move(forward, side, ?bool)` | |
| `:upmove()` / `:set_upmove(v)` | |
| `:view_angles()` → vector / `:set_view_angles(v)` / `:lock_angles()` | |
| `:rotate_movement(yaw, ?bool)` | |
| `:mouse_delta()` → `dx, dy` | |
| `:predicted()` → boolean | |
| `:subticks()` → `{ {index, when, button, pressed, forward, left, pitch, yaw, is_button}, ... }` | |
| `:add_subtick({when, button, pressed, yaw, left, forward})` → boolean | |
| `:clear_subticks()` | |
| `:add_button(btn, when?, pressed?)` → boolean / `:remove_button(btn)` | |

Константы `buttons.*` (и `button.*`): `attack=1, jump=2, duck=4, forward=8, back=16, use=32, left=512, right=1024, attack2=2048, reload=8192, speed=65536` (`button.sprint=65536`, `button.score=8589934592`).
Константы `stage.*`: `lagcomp=6, net_update_end=7, render_start=12`.

<a id="view"></a>

## 10. `wl.view` (аргумент `override_view`)
`fov()`, `set_fov(v)`, `viewmodel_fov()`, `set_viewmodel_fov(v)`, `origin()`, `set_origin(v)`, `angles()`, `set_angles(v)`, `aspect()`.

<a id="event"></a>

## 11. `wl.event` (игровые события)
`name()`, `get_int(key)`, `get_float(key)`, `get_bool(key)`, `get_string(key)`, `get_controller(key)` → wl.entity, `get_pawn(key)` → wl.entity.

---

<a id="particle"></a>

## 12. `particle`
```lua
particle.create(name: string, attach?: int) -> wl.particle
particle.precache(name)
particle.override(game_path: string (.vpcf), file: string) -> true | nil, err   -- из scripts\particles
particle.attach.{absorigin=0, absorigin_follow=1, customorigin=2, customorigin_follow=3,
                 point=4, point_follow=5, eyes_follow=6, overhead_follow=7, worldorigin=8, rootbone_follow=9}
```
`wl.particle` (методы возвращают self): `set_point(cp, vector | x, y, z)`, `set_color(cp, color)`, `bind(cp, entity, attach?, attachment?: string)`, `path({vector, ...})` (не меньше 2 точек), `lifetime(seconds)`, `destroy()`, `valid()`, `index()`. Номер control point: 0..63.

<a id="esp"></a>

## 13. `esp`
```lua
el = esp.add_text(name, fn, opts?) -> wl.esp_element
el = esp.add_bar (name, fn, opts?)
el = esp.add_icon(name, fn, opts?)
-- opts: { side = "top"|"bottom"|"left"|"right", color = color, second = color, size = int, small = bool, text = bool }
-- fn(entity, bool, entity|nil) -> значение элемента   (назначение аргументов точно не установлено)
esp.remove(name)
```
`wl.esp_element`: `remove()`, `settings(target="enemy"|"team"|"local")` → `{enabled, side, color, second, size, text}`.

<a id="utils"></a>

## 14. `utils`
`base64_encode(s)`, `base64_decode(s)`, `fnv1a(s)` → number, `murmur2(s, seed?)` → number, `time()` → number, `date(fmt="%Y-%m-%d %H:%M:%S", time?)` → string, `clipboard_get()` / `clipboard_set(s)` (**insecure**).

---

<a id="insecure"></a>

## 15. Insecure API (только при *allow insecure*)

### `memory`
```lua
memory.read(type, address) -> value
memory.write(type, address, value)
memory.find_pattern(module, pattern) -> address | nil     -- "48 8B ? ?"
memory.module(name) -> base, size
memory.export(module, name) -> address
memory.interface(module, name) -> address                 -- через CreateInterface
```

### `file` (корень `C:\neverwin\scripts\data`)
`read(name)` → string | nil, "cannot open"; `write(name, data)` → boolean; `append(name, data)` → boolean; `exists(name)` → boolean; `remove(name)` → boolean; `list(dir?)` → `{ name, ... }`.

### `http`
```lua
http.get(url, opts?, callback)
http.post(url, body, opts?, callback)
-- opts: { headers = { [k] = v }, timeout = seconds }
-- возврат: true | false, "too many requests running"
-- callback(res): res = { ok: bool, status: int, body: string, error: string, headers: { [k] = v } }
```

### `hooks` (до 64 хуков)
```lua
hook, original = hooks.add(target, ctype: string, fn)   -- Lua-обёртка: ffi.cast(ctype, fn), колбэк сохраняется от GC
hook          = hooks.add(target, callback_address)     -- target/callback: число или cdata
hooks.remove(hook) -> boolean
hooks.list() -> { wl.hook, ... }
```
`wl.hook`: `original()` → address, `target()` → address, `active()` → boolean, `remove()` → boolean.

### `ffi`
Стандартный LuaJIT FFI, доступен только в insecure-режиме.

---

<a id="addresses"></a>

## Приложение A. Адреса ключевых функций LuaJIT C API в бинаре
| Функция | Адрес | | Функция | Адрес |
|---|---|---|---|---|
| lua_setfield | 0x18047F8E0 | | lua_getfield | 0x18047EB70 |
| lua_pushcclosure | 0x18047F2B0 | | lua_createtable | 0x18047E8F0 |
| luaL_newmetatable | 0x18047E380 | | lua_setmetatable | 0x18047F990 |
| lua_settop | 0x18047FB50 | | lua_pushvalue | 0x18047F610 |
| lua_pushnumber | 0x18047F4F0 | | lua_pushinteger | 0x18047F3D0 |
| lua_pushboolean | 0x18047F270 | | lua_pushstring | 0x18047F530 |
| lua_pushlstring | 0x18047F450 | | lua_pushnil | 0x18047F4D0 |
| lua_newuserdata | 0x18047EFB0 | | lua_touserdata | 0x18047FD90 |
| luaL_checkudata | 0x18047E2C0 | | luaL_testudata | 0x18047E680 |
| luaL_checklstring | 0x18047E090 | | luaL_optlstring | 0x18047E510 |
| luaL_checknumber | 0x18047E140 | | luaL_optnumber | 0x18047E5F0 |
| luaL_checkinteger | 0x18047E010 | | luaL_optinteger | 0x18047E470 |
| luaL_checktype | 0x18047E240 | | lua_type | 0x18047FE10 |
| luaL_error | 0x180484C10 | | luaL_ref / unref | 0x1804851B0 / 0x180485280 |
| lua_pcall | 0x18047F190 | | luaL_loadstring | 0x180482E70 |

Хелперы скрипта: `check_color` 0x180063EB0, `check_vector` 0x180063D70, `check_ui` 0x180053900, `push_ui` 0x1800540B0, `ui_create` 0x180053B10, регистратор API 0x1800641B0, песочница 0x18006EE50, загрузчик скрипта 0x180070B90.


---

<a id="embedded"></a>

## Приложение B. Встроенный Lua-код (дословно)

### B.1 vector / color / math / json (`0x1806E1C10`)
```lua
local sqrt, floor, atan2, sin, cos, pi = math.sqrt, math.floor, math.atan2, math.sin, math.cos, math.pi
local type, setmetatable, rawget, tostring, tonumber, format = type, setmetatable, rawget, tostring, tonumber, string.format

local vector_mt = {}
vector_mt.__index = vector_mt
local function vector(x, y, z) return setmetatable({ x = x or 0, y = y or 0, z = z or 0 }, vector_mt) end
local function as_vector(v) return type(v) == 'number' and vector(v, v, v) or v end
vector_mt.__add = function(a, b) a, b = as_vector(a), as_vector(b) return vector(a.x + b.x, a.y + b.y, a.z + b.z) end
vector_mt.__sub = function(a, b) a, b = as_vector(a), as_vector(b) return vector(a.x - b.x, a.y - b.y, a.z - b.z) end
vector_mt.__mul = function(a, b) a, b = as_vector(a), as_vector(b) return vector(a.x * b.x, a.y * b.y, a.z * b.z) end
vector_mt.__div = function(a, b) a, b = as_vector(a), as_vector(b) return vector(a.x / b.x, a.y / b.y, a.z / b.z) end
vector_mt.__unm = function(a) return vector(-a.x, -a.y, -a.z) end
vector_mt.__eq = function(a, b) return a.x == b.x and a.y == b.y and a.z == b.z end
vector_mt.__tostring = function(a) return format('vector(%.3f, %.3f, %.3f)', a.x, a.y, a.z) end
function vector_mt:length() return sqrt(self.x * self.x + self.y * self.y + self.z * self.z) end
function vector_mt:length_sqr() return self.x * self.x + self.y * self.y + self.z * self.z end
function vector_mt:length2d() return sqrt(self.x * self.x + self.y * self.y) end
function vector_mt:dist(o) return (self - o):length() end
function vector_mt:dist2d(o) return (self - o):length2d() end
function vector_mt:dot(o) return self.x * o.x + self.y * o.y + self.z * o.z end
function vector_mt:cross(o) return vector(self.y * o.z - self.z * o.y, self.z * o.x - self.x * o.z, self.x * o.y - self.y * o.x) end
function vector_mt:normalized() local l = self:length() if l == 0 then return vector() end return vector(self.x / l, self.y / l, self.z / l) end
function vector_mt:clone() return vector(self.x, self.y, self.z) end
function vector_mt:unpack() return self.x, self.y, self.z end
function vector_mt:is_zero() return self.x == 0 and self.y == 0 and self.z == 0 end
function vector_mt:lerp(o, t) return vector(self.x + (o.x - self.x) * t, self.y + (o.y - self.y) * t, self.z + (o.z - self.z) * t) end
function vector_mt:forward()
    local p, y = self.x * pi / 180, self.y * pi / 180
    return vector(cos(p) * cos(y), cos(p) * sin(y), -sin(p))
end
function vector_mt:angle_vectors()
    local p, y, r = self.x * pi / 180, self.y * pi / 180, self.z * pi / 180
    local sp, cp, sy, cy, sr, cr = sin(p), cos(p), sin(y), cos(y), sin(r), cos(r)
    local forward = vector(cp * cy, cp * sy, -sp)
    local right = vector(-sr * sp * cy + cr * sy, -sr * sp * sy - cr * cy, -sr * cp)
    local up = vector(cr * sp * cy + sr * sy, cr * sp * sy - sr * cy, cr * cp)
    return forward, right, up
end
function vector_mt:angles()
    local yaw = atan2(self.y, self.x) * 180 / pi
    local pitch = atan2(-self.z, sqrt(self.x * self.x + self.y * self.y)) * 180 / pi
    return vector(pitch, yaw, 0)
end
_G.vector = vector

local color_mt = {}
color_mt.__index = color_mt
local function color(r, g, b, a)
    if type(r) == 'string' then
        local hex = r:gsub('#', '')
        local function byte(i) return tonumber(hex:sub(i, i + 1), 16) or 255 end
        return setmetatable({ r = byte(1), g = byte(3), b = byte(5), a = #hex >= 8 and byte(7) or 255 }, color_mt)
    end
    return setmetatable({ r = r or 255, g = g or r or 255, b = b or r or 255, a = a or 255 }, color_mt)
end
color_mt.__eq = function(a, b) return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a end
color_mt.__tostring = function(c) return format('color(%d, %d, %d, %d)', c.r, c.g, c.b, c.a) end
function color_mt:alpha(a) return color(self.r, self.g, self.b, a) end
function color_mt:lerp(o, t) return color(self.r + (o.r - self.r) * t, self.g + (o.g - self.g) * t, self.b + (o.b - self.b) * t, self.a + (o.a - self.a) * t) end
function color_mt:unpack() return self.r, self.g, self.b, self.a end
function color_mt:hex() return format('%02x%02x%02x%02x', floor(self.r), floor(self.g), floor(self.b), floor(self.a)) end
_G.color = color
function color_mt:hsv()
    local r, g, b = self.r / 255, self.g / 255, self.b / 255
    local high, low = math.max(r, g, b), math.min(r, g, b)
    local d = high - low
    local h = 0
    if d > 0 then
        if high == r then h = ((g - b) / d) % 6
        elseif high == g then h = (b - r) / d + 2
        else h = (r - g) / d + 4 end
        h = h / 6
        if h < 0 then h = h + 1 end
    end
    return h, high > 0 and d / high or 0, high
end
function color_mt:darken(f) f = 1 - math.max(0, math.min(1, f or 0.5)) return color(self.r * f, self.g * f, self.b * f, self.a) end
function color_mt:lighten(f) f = math.max(0, math.min(1, f or 0.5)) return color(self.r + (255 - self.r) * f, self.g + (255 - self.g) * f, self.b + (255 - self.b) * f, self.a) end
function color_mt:gray() local l = self.r * 0.299 + self.g * 0.587 + self.b * 0.114 return color(l, l, l, self.a) end
_G.color_hsv = function(h, s, v, a)
    h = (h % 1) * 6
    local i = math.floor(h)
    local f = h - i
    local p, q, t = v * (1 - s), v * (1 - s * f), v * (1 - s * (1 - f))
    local r, g, b
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    else r, g, b = v, p, q end
    return color(r * 255, g * 255, b * 255, a or 255)
end
_G.color_percent = function(p, a)
    p = math.max(0, math.min(1, p or 0))
    return color(255 * math.min(1, (1 - p) * 2), 255 * math.min(1, p * 2), 0, a or 255)
end

function math.clamp(v, lo, hi) if v < lo then return lo elseif v > hi then return hi end return v end
function math.lerp(a, b, t) return a + (b - a) * t end
function math.round(v) return floor(v + 0.5) end
function math.remap(v, a, b, c, d) return c + (v - a) * (d - c) / (b - a) end
function math.normalize_angle(a) a = a % 360 if a > 180 then a = a - 360 end return a end
function math.calc_angle(from, to) return (to - from):angles() end

local json = {}
json.null = setmetatable({}, { __tostring = function() return 'null' end })
local escapes = { ['"'] = '\\"', ['\\'] = '\\\\', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t' }
local function encode(value, depth)
    depth = depth or 0
    if depth > 200 then error('json.encode: too deep', 0) end
    local kind = type(value)
    if value == nil or value == json.null then return 'null' end
    if kind == 'boolean' then return tostring(value) end
    if kind == 'number' then
        if value ~= value or value == math.huge or value == -math.huge then return 'null' end
        return value == floor(value) and format('%d', value) or format('%.14g', value)
    end
    if kind == 'string' then
        return '"' .. value:gsub('[%c"\\]', function(c) return escapes[c] or format('\\u%04x', c:byte()) end) .. '"'
    end
    if kind == 'table' then
        local count = #value
        local is_array = count > 0 or next(value) == nil
        if is_array then
            for k in pairs(value) do if type(k) ~= 'number' or k > count or k < 1 or k % 1 ~= 0 then is_array = false break end end
        end
        local parts = {}
        if is_array then
            for i = 1, count do parts[i] = encode(value[i], depth + 1) end
            return '[' .. table.concat(parts, ',') .. ']'
        end
        for k, v in pairs(value) do parts[#parts + 1] = encode(tostring(k)) .. ':' .. encode(v, depth + 1) end
        return '{' .. table.concat(parts, ',') .. '}'
    end
    error('json.encode: cannot encode a ' .. kind, 0)
end
json.encode = function(v) return encode(v) end

function json.decode(text)
    if type(text) ~= 'string' then return nil, 'json.decode: a string is needed' end
    local pos = 1
    local function fail(what) error({ json = 'json.decode: ' .. what .. ' at ' .. pos }) end
    local function skip() pos = text:find('[^ \t\r\n]', pos) or #text + 1 end
    local value
    local function str()
        local out, i = {}, pos + 1
        while true do
            local c = text:sub(i, i)
            if c == '' then fail('unterminated string') end
            if c == '"' then pos = i + 1 break end
            if c == '\\' then
                local e = text:sub(i + 1, i + 1)
                local map = { b = '\b', f = '\f', n = '\n', r = '\r', t = '\t', ['"'] = '"', ['\\'] = '\\', ['/'] = '/' }
                if map[e] then out[#out + 1] = map[e] i = i + 2
                elseif e == 'u' then
                    local code = tonumber(text:sub(i + 2, i + 5), 16) or fail('bad escape')
                    if code < 0x80 then out[#out + 1] = string.char(code)
                    elseif code < 0x800 then out[#out + 1] = string.char(0xC0 + floor(code / 64), 0x80 + code % 64)
                    else out[#out + 1] = string.char(0xE0 + floor(code / 4096), 0x80 + floor(code / 64) % 64, 0x80 + code % 64) end
                    i = i + 6
                else fail('bad escape') end
            else out[#out + 1] = c i = i + 1 end
        end
        return table.concat(out)
    end
    value = function(depth)
        if depth > 200 then fail('too deep') end
        skip()
        local c = text:sub(pos, pos)
        if c == '{' then
            local out = {}
            pos = pos + 1 skip()
            if text:sub(pos, pos) == '}' then pos = pos + 1 return out end
            while true do
                skip()
                if text:sub(pos, pos) ~= '"' then fail('key expected') end
                local key = str() skip()
                if text:sub(pos, pos) ~= ':' then fail("':' expected") end
                pos = pos + 1
                out[key] = value(depth + 1) skip()
                local d = text:sub(pos, pos) pos = pos + 1
                if d == '}' then return out end
                if d ~= ',' then fail("',' or '}' expected") end
            end
        elseif c == '[' then
            local out = {}
            pos = pos + 1 skip()
            if text:sub(pos, pos) == ']' then pos = pos + 1 return out end
            while true do
                out[#out + 1] = value(depth + 1) skip()
                local d = text:sub(pos, pos) pos = pos + 1
                if d == ']' then return out end
                if d ~= ',' then fail("',' or ']' expected") end
            end
        elseif c == '"' then return str()
        elseif text:sub(pos, pos + 3) == 'true' then pos = pos + 4 return true
        elseif text:sub(pos, pos + 4) == 'false' then pos = pos + 5 return false
        elseif text:sub(pos, pos + 3) == 'null' then pos = pos + 4 return json.null
        else
            local number = text:match('^-?%d+%.?%d*[eE]?[-+]?%d*', pos)
            if not number or number == '' then fail('unexpected character') end
            pos = pos + #number
            return tonumber(number)
        end
    end
    local ok, result = pcall(value, 0)
    if not ok then
        if type(result) == 'table' and result.json then return nil, result.json end
        error(result, 0)
    end
    skip()
    if pos <= #text then return nil, 'json.decode: trailing characters at ' .. pos end
    return result
end
_G.json = json
```

### B.2 db (`0x1806E0EC0`, в оригинале одной строкой)
```lua
local read, write = db._read, db._write db._read, db._write = nil, nil
function db.save(name, value) return write(name, json.encode(value)) end
function db.load(name, default) local text = read(name) if not text then return default end local value = json.decode(text) if value == nil then return default end return value end
```

### B.3 hooks.add (`0x1806E7220`)
```lua
local raw = hooks.add
local keep = {}
hooks.add = function(target, a, b)
    if type(a) ~= 'string' then return raw(target, a) end
    local callback = ffi.cast(a, b)
    local hook = raw(target, callback)
    keep[hook] = callback
    return hook, ffi.cast(a, hook:original())
end
```
