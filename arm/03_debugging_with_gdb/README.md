# Debugging with GDB

## Debugger Setup

In this lesson we'll be setting up your enviornment to build your ARM assembly applications.

The path you take in this lesson will depend on whether or not your CPU is ARM native.

```bash
$ cat /proc/cpu
```

The output of this command will tell you the architecture of your CPU, and what commands you should run

## Non ARM Native (Intel)

Install the required tools.

```bash
$ sudo apt install gdb-multiarch
```

Write the test code (see [test.c](test.c)).

Assembly the test code using the cross compiler.

```bash
$ arm-linux-gnueabihf-gcc -o test test.c -static
```

Run the program in gdb server

```bash
$ qemu-arm ./test -g 4242
```

Debug the program

```bash
$ gdb-multiarch 
(gdb) file ./test
(gdb) target remote localhost:4242
```

## ARM Native

Install the required tools.

```bash
$ sudo apt install gdb
```

Write the test code (see [test.c](test.c)).

Assembly the test code using the cross compiler.

```bash
$ gcc -o test test.c -static
```

Run the program in gdb

```bash
$ gdb ./test
hey there this is ARM:)
```

## Conclusion

Good job! You can now debug ARM code on your machine. Keep going!
