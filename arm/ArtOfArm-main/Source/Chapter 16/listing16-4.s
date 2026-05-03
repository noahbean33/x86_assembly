// Listing 16-4            
//
// File I/O demonstration:

            #include    "aoaa.inc"
            #include    "files/files.inc"
            #include    <sys/syscall.h>


            #if isMacOS

// Map main to "_main" as macOS requires
// underscores in front of global names
// (inherited from C code, anyway).

#define main _main
sys_Exit    =   SYS_exit

            #else
    
sys_Exit    =   __NR_exit   

            #endif


            .data


// Buffer to hold line of text read from user:

inputLn:    .space  256, (0)
inputLn.len =       .-inputLn

// Buffer to hold data read from a file:

fileBuffer: .space  4096, (0)
fileBuffer.len =    .-fileBuffer


// Prompt the user for a filename:
               
prompt:     .ascii  "Enter (text) filename:"
prompt.len  =       .-prompt
            .byte   0

// Error message string:

badOpenMsg: wastr   "Could not open file\n"
               
OpenMsg:    wastr   "Opening file: "
               
            .code


         
//**********************************************************
//
// Here is the "asmMain" function.

       
            proc    main, public
            
            locals  am
            dword   am.inHandle
            byte    am_stkSpace, 64
            endl    am
            
            enter   am.size
            
// Get a filename from the user:

            lea     x0, prompt
            bl      stdout.puts

            lea     x0, inputLn
            mov     x1, #inputLn.len
            bl      stdin.readln
            cmp     x0, #0
            bmi     badOpen
            
            lea     x0, OpenMsg
            bl      stdout.puts
            lea     x0, inputLn
            bl      stdout.puts
            bl      stdout.newLn
            
// Open the file, read its contents, and display
// the contents to the standard output device

            lea     x0, inputLn
            mov     x1, #O_RDONLY
            bl      file.open
            cmp     x0, xzr
            ble     badOpen

            str     x0, [fp, #am.inHandle]
                                    
// Read the file 4,096 bytes at a time:

readLoop:   ldr     x0, [fp, #am.inHandle]
            lea     x1, fileBuffer
            mov     x2, fileBuffer.len
            bl      file.read
            
            // Quit if there was an error or
            // file.read read zero bytes:
            
            cmp     x0, xzr
            ble     allDone
            
            // Write the data just read to the
            // stdout device:
            
            mov     x2, x0        //Bytes to write
            lea     x1, fileBuffer
            mov     x0, #stdout
            bl      file.write
            b.al    readLoop
            
badOpen:    lea     x0, badOpenMsg
            bl      stdout.puts
            
allDone:    ldr     x0, [fp, #am.inHandle]
            bl      file.close
            
            // Return error code 0 to the OS:
            
            mov     svcReg, #sys_Exit
            mov     x0, #0
            svc     #OSint
            
            endp    main
            
