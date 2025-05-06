org 0x7c00
start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    jmp main

file_table:
    db "file1.txt", 0
    db "file2.txt", 0
    db "file3.txt", 0

main:
    call clear_screen
    call display_menu  ; Display main menu

main_loop:
    call get_input      ; Wait for user input
    cmp al, '1'
    je display_files    ; Show file list if input is '1'
    cmp al, '2'
    je rename_file      ; Rename file if input is '2'
    cmp al, '3'
    je delete_file      ; Delete file if input is '3'
    jmp main_loop

display_menu:
    mov si, menu_message
    call print_string
    ret

menu_message db "1.Show Files 2.Rename File 3.Delete File", 0x0A, 0x0D, "Choice: ", 0

display_files:
    call clear_screen
    mov si, display_files_message
    call print_string
    mov cx, 3             ; Number of files to display
    mov di, file_table
.display_loop:
    cmp cx, 0
    je return_to_menu      ; Return to menu after showing all files
    mov si, di
    call print_string_from_memory
    mov al, 0x0A
    call print_char        ; Print newline after each file
    add di, 10
    dec cx
    jmp .display_loop

display_files_message db "Files:\n", 0

rename_file:
    call clear_screen
    mov si, rename_file_message
    call print_string
    call get_input_string  ; Get new file name from user
    mov si, input_buffer
    mov di, file_table     ; Rename the first file in the table
    mov cx, 10
    rep movsb
    mov si, rename_success_message
    call print_string
    jmp return_to_menu

rename_file_message db "Enter new name: ", 0
rename_success_message db "Rename successful.\n", 0

delete_file:
    call clear_screen
    mov si, delete_file_message
    call print_string
    call get_input_string  ; Get file name to delete from user
    mov si, input_buffer
    mov di, file_table
    mov cx, 10
    repe cmpsb             ; Compare input with file names
    jne delete_not_found    ; If no match, jump to not found
    mov di, file_table
    mov cx, 10
    xor al, al
    rep stosb              ; Clear the file entry
    mov si, delete_success_message
    call print_string
    jmp return_to_menu

delete_not_found:
    mov si, delete_not_found_message
    call print_string      ; Inform user file was not found
    jmp return_to_menu

delete_file_message db "Enter name to delete: ", 0
delete_success_message db "Delete successful.\n", 0
delete_not_found_message db "File not found.\n", 0

return_to_menu:
    jmp main_loop

input_buffer:
    times 10 db 0

get_input:
    xor ax, ax
    mov ah, 0x00
    int 0x16               ; Wait for key press
    ret

get_input_string:
    mov di, input_buffer
    mov cx, 10             ; Limit input length to 10 characters
    xor bx, bx
.get_char:
    mov ah, 0x00
    int 0x16               ; Get single character from user
    cmp al, 0x0D
    je .done_input         ; End input on Enter key
    stosb
    call print_char        ; Echo character to screen
    loop .get_char
.done_input:
    mov al, 0
    stosb                  ; Null-terminate the input
    ret

print_string:
    lodsb
    or al, al
    jz .done               
    mov ah, 0x0E
    int 0x10             
    jmp print_string
.done:
    ret

print_string_from_memory:
    lodsb
    or al, al
    jz .done_mem          
    mov ah, 0x0E
    int 0x10               
    jmp print_string_from_memory
.done_mem:
    ret

print_char:
    mov ah, 0x0E
    int 0x10              
    ret

clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10               ; Clear screen
    ret

times 510-($-$$) db 0
dw 0xAA55
