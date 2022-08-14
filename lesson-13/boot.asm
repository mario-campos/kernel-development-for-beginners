; Origin: configures the assembler to assume that execution starts at address 0.
ORG 0

; Tell the assembler this this is for a 16-bit architecture.
BITS 16

_start:
    jmp short start
    nop       ; This NOP is the first field of the BIOS Parameter Block (BPB).

times 33 db 0 ; The remaining 34 bytes of the BPB are simply zero, as they are
              ; not necessary at this stage. This is where the BIOS may overwrite
              ; some memory.

start:
    ; This jmp instruction ensures that our code segment begins at 0x7c00.
    jmp 0x7c0:step2

; This subroutine, which prints the character 'A' to the screen, handles interrupt 0.
handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret            ; Interrupt RETurn

; This subroutine, which prints the character 'V' to the screen, handles interrupt 1.
handle_one:
    mov ah, 0eh
    mov al, 'V'
    mov bx, 0x00
    int 0x10
    iret            ; Interrupt RETurn

step2:
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

    ; Install our interrupt handlers by overwriting entries in the Interrupt Vector Table (IVT).
    ; The `word[ss:0x...]` syntax specifies the address relative to the Stack Segment (SS) register,
    ; which points to absolute address 0, which is where our IVT is located. If we don't use
    ; this syntax, `mov` defaults writes to the Data Segment (DS).
    mov word[ss:0x00], handle_zero  ; The first 16-bit word is the offset.
    mov word[ss:0x02], 0x7c0        ; The last 16-bit word is the segment.
    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0

    int 1

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
