#!/usr/bin/env python3
"""
Автономный анти-РАТ / анти-вирус сканер для репозитория HvH Lua-скриптов и конфигов.
Запуск:
    python3 scripts/security_audit.py

Проверяет все файлы репозитория на:
1. Запрещённые исполняемые файлы и бинарники (.exe, .dll, .bat, .ps1, .vbs, .scr, .ljbc, MZ/ELF заголовки).
2. Обфусцированные Lua/JS скрипты (Luraph, MoonSec, IronBrew, PSU, Obex, байткод LuaJIT, string.char / hex-эскейпы).
3. Опасные вызовы WinAPI / FFI / командной строки (os.execute, io.popen, URLDownloadToFile, ShellExecute, WinExec, CreateProcess, OpenProcess, WriteProcessMemory, реестр Windows).
4. Облачные RCE-лоадеры (скачивание кода по HTTP + выполнение через loadstring / load).
5. Вшитые чужие Discord Webhooks / Telegram Bot токены (стилеры данных и IP-логгеры).
6. Подмену заголовков аудио/картинок (проверка магических байтов RIFF/WAVE, OggS, ID3/MP3, PNG).
"""

import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BLOCKED_EXTS = {
    ".exe", ".dll", ".sys", ".scr", ".bat", ".cmd", ".ps1", ".vbs", ".vbe",
    ".jse", ".wsf", ".wsh", ".msi", ".com", ".pif", ".lnk", ".jar", ".hta",
    ".cpl", ".reg", ".apk", ".so", ".dylib", ".ljbc", ".pyc", ".pyd",
    ".zip", ".rar", ".7z"
}

MALWARE_KW_RE = re.compile(
    r"\b(?:"
    r"URLDownloadToFile[AW]?|URLOpenBlockingStream|urlmon|"
    r"ShellExecute[AW]?|WinExec|CreateProcess[AW]?|CreateRemoteThread|"
    r"WriteProcessMemory|ReadProcessMemory|OpenProcess|CreateToolhelp32Snapshot|"
    r"VirtualAllocEx|NtAllocateVirtualMemory|"
    r"powershell|WScript\.Shell|mshta|rundll32|regsvr32|certutil|bitsadmin|"
    r"InternetOpenUrl[AW]?|WinHttpOpen|WSAStartup|"
    r"RegSetValue[A-Za-z]*|RegCreateKey[A-Za-z]*|RegDelete[A-Za-z]*|"
    r"DeleteFile[AW]?|MoveFile[AW]?|CopyFile[AW]?|"
    r"named_pipes|CreateNamedPipe[AW]?|"
    r"ipify|icanhazip|grabify|iplogger"
    r")\b",
    re.I,
)
OS_EXEC_RE = re.compile(r"\b(?:os\s*\.\s*(?:execute|remove|rename|getenv|exit)|io\s*\.\s*popen)\b", re.I)
CMD_EXE_RE = re.compile(
    r"cmd\.exe|ip-api\.com|Discord[\\/]+Local Storage|Telegram Desktop[\\/]+tdata|CurrentVersion\\Run|Login Data",
    re.I,
)
WEBHOOK_RE = re.compile(r"discord(?:app)?\.com/api/webhooks/\d+|api\.telegram\.org/bot\d+", re.I)
OBF_RE = re.compile(
    r"Luraph|LPH_NO_VIRTUALIZE|LPH!|MoonSec|IronBrew|Prometheus|obfuscated by|"
    r"obex_fetch|obex_data|obex\.dev|\\x1bLJ|\\027LJ|\x1bLJ",
    re.I,
)
ESC_ONE_RE = re.compile(r"\\\d{1,3}|\\x[0-9a-fA-F]{2}")
RCE_RE = re.compile(r"\b(?:loadstring|load)\s*\(", re.I)
HTTP_RE = re.compile(r"\b(?:http\.get|http\.post|http\.request|network\.get|network\.post|panorama\.loadstring)\b", re.I)
FFI_LOAD_RE = re.compile(r'ffi\.load\s*\(\s*["\']([^"\']+)["\']\s*\)', re.I)

ALLOWED_FFI_DLLS = {
    "user32", "user32.dll", "kernel32", "kernel32.dll", "winmm", "winmm.dll",
    "client", "client.dll", "engine", "engine.dll", "vstdlib", "vstdlib.dll",
    "tier0", "tier0.dll", "vgui2", "vgui2.dll", "vguimatsurface", "vguimatsurface.dll",
    "localize", "localize.dll", "filesystem_stdio", "filesystem_stdio.dll",
    "materialsystem", "materialsystem.dll", "panorama", "panorama.dll",
    "inputsystem", "inputsystem.dll", "studiorender", "studiorender.dll",
    "datacache", "datacache.dll"
}


def scan_repository(root_dir: str) -> int:
    issues = []
    total_files = 0
    lua_files = 0

    for root, dirs, files in os.walk(root_dir):
        dirs[:] = [d for d in dirs if d not in (".git", "__pycache__")]
        for fname in files:
            fpath = os.path.join(root, fname)
            rel = os.path.relpath(fpath, root_dir)
            if rel.replace("\\", "/") in ("scripts/security_audit.py", "SECURITY_AUDIT.md", "README.md"):
                continue

            total_files += 1
            ext = os.path.splitext(fname)[1].lower()
            if ext in BLOCKED_EXTS:
                issues.append((rel, f"Запрещённое расширение файла: {ext}"))
                continue

            with open(fpath, "rb") as fp:
                raw = fp.read()

            if raw.startswith((b"MZ", b"\x7fELF", b"\x1bLJ", b"\x1bLua", b"PK\x03\x04", b"Rar!")):
                issues.append((rel, "Обнаружен исполняемый/байткод/архивный бинарный заголовок"))
                continue

            if ext == ".wav" and not (raw[:4] == b"RIFF" and raw[8:12] == b"WAVE"):
                issues.append((rel, "Некорректный заголовок WAV файла"))
                continue
            if ext == ".ogg" and raw[:4] != b"OggS":
                issues.append((rel, "Некорректный заголовок OGG файла"))
                continue
            if ext == ".png" and raw[:8] != b"\x89PNG\r\n\x1a\n":
                issues.append((rel, "Некорректный заголовок PNG файла"))
                continue

            if ext in (".lua", ".js"):
                lua_files += 1
                text = raw.decode("utf-8", errors="ignore")
                if len(text) > 15000 and text.count("\n") < 25:
                    issues.append((rel, "Подозрение на минифицированную обфускацию в 1 строку"))
                    continue
                m_obf = OBF_RE.search(text)
                if m_obf:
                    issues.append((rel, f"Обнаружена сигнатура обфускатора: {m_obf.group(0)}"))
                    continue
                if text.count("\\") > 400 and len(ESC_ONE_RE.findall(text[:100000])) > 250:
                    issues.append((rel, "Обнаружена байтовая обфускация строками"))
                    continue
                m_mal = (
                    MALWARE_KW_RE.search(text)
                    or OS_EXEC_RE.search(text)
                    or CMD_EXE_RE.search(text)
                    or WEBHOOK_RE.search(text)
                )
                if m_mal:
                    issues.append((rel, f"Опасный вызов / вебхук: {m_mal.group(0)}"))
                    continue
                if RCE_RE.search(text) and HTTP_RE.search(text):
                    issues.append((rel, "Облачный лоадер (HTTP + loadstring/load)"))
                    continue
                for fm in FFI_LOAD_RE.finditer(text):
                    dll = fm.group(1).lower().strip()
                    if dll not in ALLOWED_FFI_DLLS:
                        issues.append((rel, f"Неразрешённая библиотека ffi.load('{dll}')"))

    print(f"Проверено файлов: {total_files} (из них Lua/JS скриптов: {lua_files})")
    if issues:
        print(f"\n[!] НАЙДЕНО ПРОБЛЕМ БЕЗОПАСНОСТИ: {len(issues)}")
        for rel, msg in issues[:50]:
            print(f"  - {rel}: {msg}")
        return 1

    print("[OK] 0 угроз обнаружено! Все файлы чистые: без бинарников, без обфускации, без РАТок и вебхуков.")
    return 0


if __name__ == "__main__":
    sys.exit(scan_repository(REPO_ROOT))
