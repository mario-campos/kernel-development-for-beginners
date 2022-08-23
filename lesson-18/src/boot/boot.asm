; Origin: configures the assembler to assume that execution starts at address 0x7c00.
ORG 0x7c00

; Tell the assembler this this is for a 16-bit architecture.
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop       ; This NOP is the first field of the BIOS Parameter Block (BPB).

times 33 db 0 ; The remaining 34 bytes of the BPB are simply zero, as they are
              ; not necessary at this stage. This is where the BIOS may overwrite
              ; some memory.

start:
    ; This jmp instruction ensures that our code segment begins at 0x7c00.
    jmp 0:step2

step2:
    ; For maximum portability, it's important that we initialize the segment registers
    ; ourselves, because the BIOS may not set the segment registers to the addresses
    ; we expect.
    cli             ; CLear Interrupts flag: disables interrupts while we are
                    ; performing the critical operation of setting the segment
                    ; registers.
    mov ax, 0x00   ; Values cannot be written directly to segment registers,
    mov ds, ax      ; so we use register ax.
    mov es, ax
    mov ss, ax      ; set up differently.
    mov sp, 0x7c00  ; The stack pointer (sp) points to the "top" of the stack.
    sti             ; SeTs Interrupts flag: enables interrupts.

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; Global Descriptor Table (GDT)
gdt_start:

; GDT entry 0: The first entry in the GDT should always be null.
gdt_null:
    dd 0x0
    dd 0x0

; GDT entry 1 (offset 0x8)
gdt_code:        ; CS
    dw 0xffff    ; Segment limit first 0-15 bits
    dw 0         ; Base first 0-15 bits
    db 0         ; Base 16-23 bits
    db 0x9a      ; Access byte
    db 11001111b ; High 4-bit flags and low 4-bit flags.
    db 0         ; Base 24-31 bits

; offset 0x10
gdt_data:        ; DS, SS, ES, FS, GS
    dw 0xffff    ; Segment limit first 0-15 bits
    dw 0         ; Base first 0-15 bits
    db 0         ; Base 16-23 bits
    db 0x92      ; Access byte
    db 11001111b ; High 4-bit flags and low 4-bit flags.
    db 0         ; Base 24-31 bits

gdt_end:

; Global Descriptor Table (GDT) Descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size (bits 0-15): The size of the GDT less one.
    dd gdt_start                ; Offset (bits 0-31): The linear address of the GDT.

[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    jmp $

; Pad the code up to 510 bytes with zeros (db 0). These
; zeroes are merely a placeholder, 
times 510-($ - $$) db 0

; dw (word, 2 bytes, 16 bits)
dw 0xaa55 ; Store 0x55 then 0xAA. As a single word, 0xaa55 is in Little Endian.