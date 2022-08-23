# Lesson 17

In this lesson, we have the bootloader enter [Protected Mode](https://wiki.osdev.org/Protected_Mode). In order to do so, we must first create a [Global Descriptor Table](https://wiki.osdev.org/Global_Descriptor_Table).

See Also:
- [Protected Mode](https://wiki.osdev.org/Protected_Mode)
- [Global Descriptor Table](https://wiki.osdev.org/Global_Descriptor_Table)

### Build

```shell
make
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
