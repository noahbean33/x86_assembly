// Listing6-1
//
//  Demonstrate using X28 as a "static base"
// register to conveniently access global
// variables

        #include    "aoaa.inc"
        
        
#define sb X28          // Use X28 for SB register

// Declaration of global variables:

    	struct  globals_t
        word    g1
        dword   g2
        hword   g3
        byte    g4,128
        ends    globals_t


        .data

        globals_t globals      // Global variables go here
        

        .text
        .pool
ttlStr: wastr  "Listing 6-1"

        
        proc    getTitle, public
        lea     x0, ttlStr
        ret
        endp    getTitle
               
        

        proc    asmMain, public
        
        locals  am
        dword   saveSB              // Save X28 here
        byte    stackSpace, 64      // Generic stack space
        endl    am
        
        enter   am.size             // Reserve space for locals
        str     sb, [fp, #saveSB]   // Preserve SB register
        lea     sb, globals     // Initialize with address
                 
        mov     w0, #55             // Just demonstrate the
        str     w0, [sb, #g1]       // use of the static
        add     x0, x0, #44         // base record in the
        str     x0, [sb, #g2]       // .data section.
        and     w0, w0, #0xff
        strh    w0, [sb, #g3]
        
        ldr     sb, [fp, #saveSB]   // Restore SB register
        leave                       // Return to caller
        endp    asmMain 