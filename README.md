# Repository-luas — Полный Чистый Архив HvH Lua, КФГ, Библиотек, Агентов, Хитсаундов и Локаций (CS:GO & CS2)

Максимально полный, структурированный и **полностью очищенный от обфускации, лоадеров, РАТок и вирусов** архив для **Gamesense (Skeet)**, **Neverlose (CS:GO & CS2)**, **Fatality (CS2)**, **Nixware (CS2)**, **Primordial** и **OneTap v4**.

За основу взят актуальный архив **`sodaconsumer-del/CSGO-HVH-LUAS`** (обновление октября 2026), который был глубоко очищен от всех обфусцированных/опасных файлов, дедуплицирован и дополнен **50+ свежими паками 2025–2026 годов** (библиотеки, конфиги с луашками и без, новые CS2 скрипты, локации на Grenade Helper, агенты и хитсаунды).

> **100% Open-Source & Anti-RAT:** В репозитории **0** `.exe`/`.dll` файлов, **0** обфусцированных скриптов (`obf` / `Luraph` / `MoonSec` / `Obex`), **0** облачных `loadstring`-лоадеров, **0** вызовов `URLDownloadToFile` / `ShellExecute` / `os.execute` / `io.popen` и **0** чужих Discord-вебхуков. Подробности — в [`SECURITY_AUDIT.md`](./SECURITY_AUDIT.md).

---

## Состав репозитория (~3 475 проверенных файлов)

| Раздел | Описание | Кол-во файлов |
| :--- | :--- | :---: |
| **[`Gamesense/`](./Gamesense)** | **Skeet (Gamesense):** открытые Lua-скрипты, свежие паки 2025–2026, ресольверы, готовая папка библиотек `lua/gamesense/`, 60+ папок КФГ (с луашками и без) и пресеты настроек Lua (`Lua-Settings`) | **1 645** |
| **[`Neverlose/`](./Neverlose)** | **Neverlose (CS:GO & CS2):** открытые Lua-скрипты для CS:GO и CS2, паки 2026 года (`Rifk7s`, `Capo`, `ScriptLeaks`), все библиотеки (`pui`, `clipboard`, `gradient`, `mtools`, `anti_aim` и др.), документация API + автодополнение для VS Code, 150+ КФГ и `Lua-Settings`, русская локализация NL CS2 | **534** |
| **[`Hitsounds/`](./Hitsounds)** | **Хитсаунды:** `CSGO-WAV-MP3-OGG/` (skeet, bell, bameware, cod, rust, primordial, rifk7, minecraft, 8bit и др.) + `CS2-VSND_C/` (готовые `.vsnd_c` звуки для CS2 Neverlose / Fatality / Nixware 2026) | **244** |
| **[`Grenade-Helper/`](./Grenade-Helper)** | **Локации на Grenade Helper:** паки раскидок, мувмента и ванвеев для CS:GO (Neverlose, Gamesense `Sapphyrus-Helper`, универсальные) и свежие локации 2026 года для **CS2** (`Fatality`, универсальные JSON и по-картовые `.cfg` для Ancient, Anubis, Dust2, Inferno, Mirage, Nuke, Vertigo) | **211** |
| **[`Agents/`](./Agents)** | **Агенты и Модели:** открытые Agent Changer / Player Model Changer / Cloud Model Changer / Arms Changer скрипты на Skeet, Neverlose, Primordial и CS2 + полные таблицы путей всех агентов CS:GO/CS2 и гайд по установке кастомных моделей | **36** |
| **[`CS2/`](./CS2)** | **Counter-Strike 2 (`Fatality` & `Nixware`):** новые открытые Lua-скрипты 2025–2026 и готовые Rage / Semi-Rage / HvH конфиги | **220** |
| **[`Primordial/`](./Primordial)** | **Primordial:** открытые Lua-скрипты, ресольверы, библиотеки (`Libraries/`), конфиги и настройки скриптов | **543** |
| **[`OTV4/`](./OTV4)** | **OneTap v4:** проверенные `.js` скрипты и конфиги | **37** |
| **[`scripts/`](./scripts)** | Автономный анти-РАТ / анти-вирус сканер `security_audit.py` для проверки любых новых файлов | **1** |

---

## Быстрая установка по клиентам

### 1. Библиотеки и Lua для Gamesense (Skeet)
Чтобы не возникало ошибок `module 'gamesense/...' not found` или `module 'vector' not found`:
1. Откройте папку [`Gamesense/Libraries/lua/`](./Gamesense/Libraries/lua).
2. Скопируйте её содержимое (`vector.lua` и подпапку `gamesense/`) в вашу папку `csgo/lua/` (или корень `Counter-Strike Global Offensive/lua/` в зависимости от лоадера):
   ```text
   Counter-Strike Global Offensive/
   ├── lua/
   │   ├── vector.lua
   │   ├── gamesense/
   │   │   ├── antiaim_funcs.lua
   │   │   ├── base64.lua
   │   │   ├── clipboard.lua
   │   │   ├── csgo_weapons.lua
   │   │   ├── ease.lua
   │   │   ├── easing.lua
   │   │   ├── entity.lua
   │   │   ├── http.lua
   │   │   ├── images.lua
   │   │   ├── pui.lua
   │   │   ├── surface.lua
   │   │   └── ... (все 35+ библиотек)
   ```
3. Сами скрипты из `Gamesense/Luas/`, `Gamesense/Luas-Extra-Packs/` и `Gamesense/Resolvers/` закидывайте в `lua/`.
4. Конфиги из `Gamesense/Configs/` и настройки луашек из `Gamesense/Lua-Settings/` импортируются через буфер обмена (`Import from clipboard`) либо кладутся в папку конфигов.

### 2. Библиотеки, Lua и КФГ для Neverlose (CS:GO & CS2)
- **Библиотеки (`Neverlose/Libraries/`):** поместите нужные модули (`pui.lua`, `clipboard.lua`, `gradient.lua`, `base64.lua`, `mtools.lua` и др.) в `nl/scripts/common/` (или `csgo/nl/lib/` в зависимости от версии).
- **Скрипты (`Neverlose/CSGO/Luas*` и `Neverlose/CS2/Luas/`):** поместите в `nl/scripts/`.
- **Конфиги (`Neverlose/Configs*`) и настройки скриптов (`Neverlose/Lua-Settings/`):** скопируйте содержимое `.txt` файла и нажмите **Import from Clipboard** в самом скрипте (например, Acidtech, Chimera, Angelwings, Luasense) или используйте скрипт импорта конфигов.
- **Русская локализация CS2 (`Neverlose/CS2/Localization-RU/ru.json`):** файл полного перевода интерфейса Neverlose CS2 на русский язык.

### 3. Хитсаунды (`Hitsounds/`)
- **Для CS:GO (Skeet / Neverlose / Primordial / OTV4):**
  Скопируйте `.wav` файлы из [`Hitsounds/CSGO-WAV-MP3-OGG/`](./Hitsounds/CSGO-WAV-MP3-OGG) в папку:
  `Steam/steamapps/common/Counter-Strike Global Offensive/csgo/sound/`
- **Для CS2 (Neverlose CS2 / Fatality CS2 / Nixware CS2):**
  Скопируйте `.vsnd_c` файлы из [`Hitsounds/CS2-VSND_C/`](./Hitsounds/CS2-VSND_C) в папку:
  `Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/sounds/`

### 4. Локации на Grenade Helper (`Grenade-Helper/`)
- **Neverlose CS:GO:** импортируйте файлы из `Grenade-Helper/CSGO-Neverlose-and-Universal/` через встроенный Grenade Helper (или положите в `nl/grenades/`). Пак `Rifk7s-Pack/nadehelper_all_maps_4.txt` покрывает сразу 30 карт!
- **Gamesense (Skeet):** используйте папку `Grenade-Helper/CSGO-Gamesense/Sapphyrus-Helper/`.
- **CS2 (Fatality и др.):** актуальные файлы 2026 года `grenades.json`, `movements.json`, `wallbangs.json` и `ImSynZx-2026-grenades.json` находятся в `Grenade-Helper/CS2-Fatality-and-Universal/`.

### 5. Агенты и Модели (`Agents/`)
Подробная инструкция по установке кастомных `.mdl` (CS:GO) и `.vmdl_c` (CS2) моделей, а также готовые таблицы всех официальных агентов находятся в [`Agents/Model-Paths-and-Guide/README.md`](./Agents/Model-Paths-and-Guide/README.md).

---

## Проверка безопасности при добавлении своих файлов

Перед тем как закидывать новые скачанные скрипты в этот репозиторий, запустите встроенный сканер:

```bash
python3 scripts/security_audit.py
```

Он автоматически проверит все файлы на отсутствие `.exe`/`.dll`, обфускаторов, `URLDownloadToFile`, `ShellExecute`, `os.execute`, `io.popen`, облачных `loadstring`-лоадеров и чужих Discord-вебхуков.
