# Environment Setup

In this lesson we'll be setting up your enviornment to build your ARM assembly applications.

The path you take in this lesson will depend on whether or not your CPU is ARM native.

```bash
$ cat /proc/cpu
```

The output of this command will tell you the architecture of your CPU, and what commands you should run

## Non ARM Native (Intel)

Install the required tools.

```bash
$ sudo apt install build-essential gcc-arm-linux-gnueabihf qemu-user
```

Write the test code (see [test.c](test.c)).

Assembly the test code using the cross compiler.

```bash
$ arm-linux-gnueabihf-gcc -o test test.c -static
```

Run the program

```bash
$ qemu-arm ./test
hey there this is ARM:)
```

## ARM Native

Install the required tools.

```bash
$ sudo apt install build-essential
```

Write the test code (see [test.c](test.c)).

Assembly the test code using the cross compiler.

```bash
$ gcc -o test test.c -static
```

Run the program

```bash
$ ./test
hey there this is ARM:)
```

## Conclusion

Good job! You can now run ARM code on your machine. Keep going!
