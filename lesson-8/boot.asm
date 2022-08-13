; Origin: configures the assembler to assume that execution starts at address 0.
ORG 0

; Tell the assembler this this is for a 16-bit architecture.
BITS 16

; This jmp instruction ensures that our code segment begins at 0x7c00.
jmp 0x7c0:start

start:
    ; For maximum portability, it's important that we initialize the segment registers
    ; ourselves, because the BIOS may not set the segment registers to the addresses
    ; we expect.
    cli             ; CLear Interrupts flag: disables interrupts while we are
                    ; performing the critical operation of setting the segment
                    ; registers.
    mov ax, 0x7c0   ; Values cannot be written directly to segment registers,
    mov ds, ax      ; so we use register ax.
    mov es, ax
    mov ax, 0       ; Since the stack grows "downward", the stack segment is
    mov ss, ax      ; set up differently.
    mov sp, 0x7c00  ; The stack pointer (sp) points to the "top" of the stack.
    sti             ; SeTs Interrupts flag: enables interrupts.

    mov si, message ; Load the start address of 'message' into the si register.
    call print
    jmp $           ; Jump to the 'start' label.

print:
    mov bx, 0 ; int 0x10 argument: page, etc.
.loop:
    ; Load a byte from the si register to al register and
    ; then increment the si register.
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh ; int 0x10 argument: "VIDEO - TELETYPE OUTPUT" command
    ; Call a BIOS routine that will output the character above
    ; to the screen. See http://www.ctyme.com/intr/int-10.htm.
    int 0x10
    ret

message: db 'Hello, World!', 0

; Pad the code up to 510 bytes with zeros (db 0). These
; zeroes are merely a placeholder, 
times 510-($ - $$) db 0

; dw (word, 2 bytes, 16 bits)
dw 0xaa55 ; Store 0x55 then 0xAA. As a single word, 0xaa55 is in Little Endian.
