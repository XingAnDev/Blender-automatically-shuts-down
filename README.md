# Blender Automation (MASM x64)

> Render overnight without staying up.  
> A no-CRT Windows tool written in pure MASM x64 that waits for your Blender output file and shuts down your PC when the render is done.

## What is this?

This is a small Windows console tool written in **pure MASM x64 assembly**.

It is designed for one simple workflow:

1. You start a long Blender render at night.
2. You tell this tool where Blender will output the final file.
3. You go to bed.
4. When the output file appears, the tool waits 60 seconds and shuts down your PC.

No C runtime. No C++. No external dependencies beyond `kernel32.lib` and `shell32.lib`.

## Features

- **Pure MASM x64** — written directly in x64 assembly
- **No CRT** — no C/C++ runtime startup code
- **Windows Unicode API** — uses `WriteConsoleW` / `ReadConsoleW`
- **Automatic shutdown** — runs `shutdown.exe /s /t 60` after the file is found
- **Cancels previous shutdown** — runs `shutdown.exe /a` on startup
- **Polling** — checks the target file every 60 seconds
- **Small and self-contained** — only links `kernel32.lib` and `shell32.lib`

## Use case

Blender renders can take hours. Instead of staying awake, run this tool, enter the output folder and target filename, and let your PC shut itself down when the render is finished.

Example:

```text
Output folder: D:\Blender\Output
Target file:   final_render.mp4
```

The tool will check:

```text
D:\Blender\Output\final_render.mp4
```

Once that file exists, it starts a 60-second shutdown timer.

## Build

You need the MSVC build tools, including `ml64.exe` and `link.exe`.

Open **x64 Native Tools Command Prompt for VS**, then run:

```bat
ml64 /c /nologo /Fo BlenderAutomation.obj BlenderAutomation.asm
link /nologo /subsystem:console /entry:main /out:BlenderAutomation.exe BlenderAutomation.obj kernel32.lib shell32.lib
```

Or create a `build.bat`:

```bat
@echo off
ml64 /c /nologo /Fo BlenderAutomation.obj BlenderAutomation.asm
if errorlevel 1 exit /b 1

link /nologo /subsystem:console /entry:main /out:BlenderAutomation.exe BlenderAutomation.obj kernel32.lib shell32.lib
if errorlevel 1 exit /b 1

echo Build OK.
```

## Usage

1. Run `BlenderAutomation.exe`.
2. Enter the Blender output folder path.
3. Enter the target filename.
4. The tool prints the full path it will monitor.
5. It checks the file every 60 seconds.
6. When the file is found, it runs:

```bat
shutdown.exe /s /t 60
```

7. Your PC shuts down after 60 seconds.

If you want to cancel the shutdown, run:

```bat
shutdown /a
```

## How it works

- On startup, it calls `shutdown.exe /a` to cancel any existing shutdown countdown.
- It reads the output folder and target filename as UTF-16 input.
- It builds the full path manually.
- It uses `GetFileAttributesW` to check whether the file exists.
- If the file does not exist, it calls `Sleep(60000)` and checks again.
- When the file appears, it calls `ShellExecuteW` to run:

```bat
shutdown.exe /s /t 60
```

## Why MASM?

Because it is fun, small, and direct.

- No CRT startup overhead
- Direct Win32 API calls
- Full control over strings, buffers, and stack alignment
- A good exercise in x64 Windows ABI, Unicode APIs, and console I/O

## Notes

- Windows x64 only.
- Console Unicode support is required for correct display.
- The input path limit is 519 characters.
- The tool does not monitor Blender directly; it only watches for the output file.
- The shutdown happens 60 seconds after the file is detected.
- If you do not want it to cancel previous shutdown timers on startup, remove the `shutdown.exe /a` call in the source.

## License

MIT
