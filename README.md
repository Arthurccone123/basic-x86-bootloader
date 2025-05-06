# Basic x86 Bootloader - File Manager

This project is a simple bootloader written in x86 Assembly that provides a basic menu-driven file management interface. It demonstrates how a computer boots from BIOS and how low-level user interaction can be implemented using real-mode interrupts.

## Features

- **Menu-based UI** in BIOS text mode
- **Show files** stored in a simple in-memory table
- **Rename file** by entering a new name
- **Delete file** by entering the file name
- Basic **string and character input handling**
- Works directly with BIOS interrupts (`int 0x10`, `int 0x16`)

## Technologies

- x86 Assembly (NASM syntax)
- Real-mode BIOS calls
- Bootable 512-byte sector

## Functions Overview

| Function         | Description                                           |
|------------------|-------------------------------------------------------|
| `get_input`      | Waits for a single keypress                           |
| `get_input_string` | Reads up to 10-character string from user input    |
| `rename_file`    | Renames the first file entry in the table             |
| `delete_file`    | Deletes a file entry if name matches user input       |
| `display_files`  | Displays current file list using BIOS text output     |

## How to Run

You can test this bootloader using [QEMU](https://www.qemu.org/) or [Bochs](http://bochs.sourceforge.net/), or write it to a floppy image:

### With QEMU

```bash
nasm -f bin Source\ Code.asm -o bootloader.img
qemu-system-i386 -fda bootloader.img
