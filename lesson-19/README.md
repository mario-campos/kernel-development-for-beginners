# Lesson 19

In this lesson, we enable the A20 line, which represents the 21st bit of memory in an address, to be able to address all memory. It seems like this is an artifact of the older 8086's limitations.

See Also:
- [A20 Line](https://wiki.osdev.org/A20_Line)

### Build

```shell
make
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
