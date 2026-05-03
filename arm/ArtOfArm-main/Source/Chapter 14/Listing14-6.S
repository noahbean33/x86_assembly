/// Listing 14-6
//
// Simple program to demonstrate UTF-8 output

            #include    "aoaa.inc"
        
            
            .data
fmtStr:     .ascii  "Unicode='"

            // e followed by U+301 (0xcc, 0x81 in UTF-8)
            
            .ascii  "e"
            .byte   0xCC, 0x81
            
            .asciz  "'\n"
            
                        
            .code
ttlStr:     wastr  "Lising14-6.S"

            proc    getTitle, public
            lea    x0, ttlStr
            ret
            endp    getTitle
                   
           

            proc    asmMain, public
            
            locals  lcl
            qword   saveX20_X21
            byte    stkSpace, 64
            endl    lcl
            
            enter   lcl.size      // Reserve space for locals
            
            lea     x0, fmtStr
            bl      printf

AllDone:    leave
            endp    asmMain 
