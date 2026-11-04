# Агенты и Кастомные Модели (CS:GO & CS2 — Skeet / Neverlose / Fatality / Primordial)

В папке `Agents/` собраны **все проверенные и открытые (без обфускации и вирусов) Lua-скрипты на смену агентов, кастомных моделей игроков, рук и оружия**:

- `Agents/Gamesense/` — скрипты смены моделей для **Gamesense (Skeet)** (`player-model-changer.lua`, `[FLAWLESS] model_changer.lua`, `Model_changer_by_Bassota.lua`, `Custom model by frisichh.lua`, `arms changer.lua` и др.)
- `Agents/Neverlose/` — скрипты смены моделей для **Neverlose** (`Cloud Model Changer_7073630.lua` от `.rifk` с раздельными моделями за T/CT, сменой масок, рук и оружия, `model changer.lua` и др.)
- `Agents/Primordial/` и `Agents/CS2/` — скрипты для **Primordial** (`Agent Changer (All models).lua`) и **CS2**
- `official_csgo_agents.lua` и `official_cs2_agents.json` — полные таблицы путей всех официальных агентов игры

---

## Куда кидать кастомные модели (`.mdl` / `.vmdl_c`)

### 1. CS:GO Legacy (Gamesense / Skeet, Neverlose CS:GO, Primordial)
1. Скачайте архив с моделью (папки `models/` и `materials/`).
2. Распакуйте их в корень папки `csgo`:
   ```text
   Steam/steamapps/common/Counter-Strike Global Offensive/csgo/
   ├── models/player/custom_player/...
   └── materials/models/player/custom_player/...
   ```
3. Скопируйте путь до `.mdl` файла начиная с `models/...` (например: `models/player/custom_player/legacy/tm_professional_vari.mdl`) и вставьте его в ваш **Model Changer Lua**!
4. Чтобы не было красной надписи `ERROR` на серверах, убедитесь, что в чите включен **Bypass sv_pure**.

### 2. Counter-Strike 2 (Neverlose CS2 / Fatality CS2 / Nixware CS2)
1. Перейдите по пути:
   ```text
   Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/
   ```
2. Создайте внутри папку `characters/models/` (если её ещё нет) и поместите туда папку со скомпилированной моделью Source 2 (`.vmdl_c` и текстуры):
   ```text
   game/csgo/characters/models/<имя_пака>/<модель>.vmdl_c
   ```
3. В **Neverlose CS2** кастомная модель автоматически появится в списке выбора агентов в меню Inventory / Skins (либо укажите путь с расширением `.vmdl` в Lua-скрипте).
