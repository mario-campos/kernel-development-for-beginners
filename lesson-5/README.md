# Lesson 5

In this lesson, we create a simple bootloader that prints a single character to the screen/terminal.

### Build

```shell
nasm -f bin -o boot.bin boot.asm
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
