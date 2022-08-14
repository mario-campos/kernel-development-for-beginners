# Lesson 15

In this lesson, we use a BIOS routine to read a sector from the disk into memory. The sector that we read from "disk" is simply a text file that we append to the bootloader, since that file gets treated as the disk by QEMU. To ensure that there's at least 512 bytes in that sector we read, we then append 512 bytes of zeroes.

Because we utilize the BIOS to read from disk, the BIOS routine utilizes an outdated addressing mode called Cylinder-Head-Sector (CHS). CHS addressing mode identifies the sector to read by specifying the parameters cylinder, head, and sector. It's rather old-fashioned and complicated, so it's been superseded by Logical Block Addressing (LBA), which simply identifies sectors by an integer starting at 0.

We also introduce a Makefile to simplify the process of building our bootloader and "disk."

See Also:
- [Cylinder-head-sector](https://en.wikipedia.org/wiki/Cylinder-head-sector)
- [Disk access using the BIOS (INT 13h)](https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h))
- [Logical Block Address](https://wiki.osdev.org/LBA)

### Build

```shell
make
```

### Run

```shell
qemu-system-x86_64 -hda ./boot.bin
```
