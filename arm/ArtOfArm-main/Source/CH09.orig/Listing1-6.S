// Listing1-6
//
// The venerable "Hello, world!" program, written
// in ARM assembly by calling the C stdlib printf
// function.
//
// The Art of ARM Assembly include file.
//
// This provides several things for us.
// First, it makes "asmFunc" global and
// automatically converts it to "_asmFunc"
// if this program is being assembled under macOS.
// It also converts "printf" to "_printf" for macOS.

            #include "aoaa.inc"
            
            .data
saveLR:     .dword  0       // Save LR here.
title:      .asciz  "Listing1-6"
hwStr:      .asciz  "Hello, world\n"
            
            .text
            
// getTitle function, required by c.cpp, returns the
// name of this program. Note that the title string
// must appear in the .text section.

            .align  2       // Code must be 4-byte aligned
getTitle:
            lea     x0, title
            ret
            
            
// Here's the main function called by the c.cpp function:

asmMain:

// First of all, LR is *highly* volatile and will
// be wiped out when this code calls the printf()
// function. So we need to save LR in memory somewhere
// so we can return back to the OS using its value.
// For right now, just save it in the "saveLR" global
// variable

            lea     x0, saveLR
            str     lr, [x0]
            
// Okay, set up printf parameter (format string)
// and call printf():

            lea     x0, hwStr   // hwStr must be in .text
            bl      printf      // Print the string
            
// Back from printf(), restore LR with its original
// value so we can return to the OS:

            lea     x0, saveLR
            ldr     lr, [x0]
            
// Return to the OS:

            ret

            
