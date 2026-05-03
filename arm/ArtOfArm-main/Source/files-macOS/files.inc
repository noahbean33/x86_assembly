// files.inc
//
// Header file that holds the files library
// globals and constants

            #include "../aoaa.inc"  //Get isMacOS and isLinux
            
            #if     isMacOS

#define O_CREAT     00000200
AT_FDCWD    =       -2

            #else
            
#define O_CREAT     00000100
AT_FDCWD    =       -100

// The library code uses the macOS naming
// convention for external names (prefixed
// underscores). For Linux, eliminate the
// underscores.

#undef write  //From aoaa.inc
#define _write write
#define _read  read
#define _openat openat
#define _close  close

            #endif

// Handles for the stdio files:
            
stdin       =       0
stdout      =       1
stderr      =       2

// Other useful constants:

cr          =       0xd     //Carriage return (ENTER)
lf          =       0xa     //Line feed/new line char
bs          =       0x8     //Backspace


// Note the following are octal (base 8) constants!
// (Leading 0 indicates octal in Gas)
//
// These constants were copied from fcntl.h.
            
#define S_IRWXU  (00700)
#define S_RDWR   (00666)
#define S_IRUSR  (00400)
#define S_IWUSR  (00200)
#define S_IXUSR  (00100)
#define S_IRWXG  (00070)
#define S_IRGRP  (00040)
#define S_IWGRP  (00020)
#define S_IXGRP  (00010)
#define S_IRWXO  (00007)
#define S_IROTH  (00004)
#define S_IWOTH  (00002)
#define S_IXOTH  (00001)
#define S_ISUID  (0004000) 
#define S_ISGID  (0002000)
#define S_ISVTX  (0001000)


#define O_RDONLY    00000000
#define O_WRONLY    00000001
#define O_RDWR      00000002
#define O_EXCL      00000200
#define O_NOCTTY    00000400
#define O_TRUNC     00001000
#define O_APPEND    00002000
#define O_NONBLOCK  00004000
#define O_DSYNC     00010000
#define FASYNC      00020000
#define O_DIRECT    00040000
#define O_LARGEFILE 00100000
#define O_DIRECTORY 00200000
#define O_NOFOLLOW  00400000
#define O_NOATIME   01000000
#define O_CLOEXEC   02000000


// Macro to test an error return
// value from an OS API call

            .macro  file.checkError

            cmp     x0, #-1
            bne     0f
            getErrno
            neg     x0, x0
0:
            .endm
            
            .extern saveVolatile
            .extern restoreVolatile
            
            .extern file.write
            .extern file.read
            .extern file.open
            .extern file.openNew
            .extern file.close

            .extern stdout.puts
            .extern stdout.newLn

            .extern stdin.read
            .extern stdin.getc
            .extern stdin.readln
            
            
            