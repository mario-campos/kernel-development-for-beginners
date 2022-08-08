; Originate (start execution) at address 0x7c00, which is
; where the BIOS will place this bootloader at boot.
ORG 0x7c00

; Tell the assembler this this is for a 16-bit architecture.
BITS 16

start:
    mov ah, 0eh  ; argument: 'VIDEO - TELETYPE OUTPUT' command.
    mov al, 'A'  ; argument: character to print to screen.
    mov bx, 0    ; argument: page, etc.
    int 0x10     ; Call BIOS routine.

    jmp $        ; Jump to the 'start' label.

; Pad the code up to 510 bytes with zeros (db 0). These
; zeroes are merely a placeholder.
times 510-($ - $$) db 0

; dw (word, 2 bytes, 16 bits)
dw 0xaa55 ; Store 0x55 then 0xAA. As a single word, 0xaa55 is in Little Endian.
