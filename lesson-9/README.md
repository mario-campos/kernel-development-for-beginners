# Lesson 9

In this lesson, we modify the previous lesson's bootloader by adding a stub [BIOS Parameter Block (BPB)](https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29), because some BIOSes may alter our bootloader when loaded from a USB drive.

These BIOSes expect a BPB in the bootloader. Moreover, they will overwrite the BPB to emulate a USB drive as a hard-disk drive. Without a BPB, our innocent, little bootloader will have its code/data overwritten. So, to fix this, we add a BPB to allow the BIOS to overwrite a harmless area of memory.

### Build

```shell
nasm -f bin -o boot.bin boot.asm
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
