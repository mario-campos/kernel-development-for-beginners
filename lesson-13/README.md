# Lesson 13

In this lesson, we learn about the [Interrupt Vector Table (IVT)](https://wiki.osdev.org/Interrupt_Vector_Table). The Interrupt Vector Table is an array, located at absolute address 0, of 256 entries to interrupt handlers. These handlers are invoked when the processor is interrupted, such as a "divide-by-zero" exception. When the processor is interrupted (via an interrupt), it will stop what it's executing, save state onto the stack, and then execute the interrupt handler, as identified by the index into the array (i.e. interrupt 0 invokes the first entry in the Interrupt Vector Table).

Each entry of the Interrupt Vector Table is 4 bytes long. The "first" two bytes (0x00-0x01) refer to the offset. The "last" two bytes (0x02-0x03) refer to the segment.

In this lesson, we modify the previous lesson's bootloader by installing two [Interrupt Vector Table](https://wiki.osdev.org/Interrupt_Vector_Table) handlers (subroutines). We write trivial subroutines to handle interrupts 0 and 1. In doing so, we overwrite the processor's "divide-by-zero" exception handler, which is at index 0 of the Interrupt Vector Table.

See Also:
- [Interrupt Vector Table](https://wiki.osdev.org/Interrupt_Vector_Table)
- [Exceptions](https://wiki.osdev.org/Exceptions)

### Build

```shell
nasm -f bin -o boot.bin boot.asm
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
