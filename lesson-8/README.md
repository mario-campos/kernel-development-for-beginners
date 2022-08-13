# Lesson 8

In this lesson, we modify lesson 5.1's bootloader with an initialization of the segment registers, because the BIOS provides no guarentees about their initial values. So, in order for this bootloader to be portable across all PCs, we must ensure that we know what the segment registers are. And the best way to guarentee that is to initialize them ourselves.

### Build

```shell
nasm -f bin -o boot.bin boot.asm
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
