# Lesson 5.1

In this lesson, we create a "Hello, World" bootloader!

### Build

```shell
nasm -f bin -o boot.bin boot.asm
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
