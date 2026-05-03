// Listing9-5.S
//
// qtoStr function (qword integer to hex conversion).

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-4"

            .data

// buffer space used by main program.

buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

// dtobuf
//
// Convert a dword to a string of 16 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          17 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3


            proc    dtobuf

#define AtoF   ('A'-'9'-1)         
            
            // Process the HO nibble:
            
            lsr     x2, x1, #60
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            bls     dec15           // Skip if 0 to 9            
            add     w2, w2, #AtoF   // If it was A to F
dec15:      
            strb    w2, [x0], #1    // Store byte to memory
            
            
            // Process nibble 14:
            
            lsr     x2, x1, #56     // See comments for HO nibble       
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec14            
            add     w2, w2, #AtoF  
dec14:      strb    w2, [x0], #1    
            
            // Process nibble 13:
            
            lsr     x2, x1, #52
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec13            
            add     w2, w2, #AtoF  
dec13:      strb    w2, [x0], #1    
            
            // Process nibble 12:
            
            lsr     x2, x1, #48
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec12            
            add     w2, w2, #AtoF  
dec12:      strb    w2, [x0], #1    
            
            // Process nibble 11:
            
            lsr     x2, x1, #44
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec11            
            add     w2, w2, #AtoF  
dec11:      strb    w2, [x0], #1    
            
            // Process nibble 10:
            
            lsr     x2, x1, #40
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec10            
            add     w2, w2, #AtoF  
dec10:      strb    w2, [x0], #1    
            
            // Process nibble 9:
            
            lsr     x2, x1, #36
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec9                 
            add     w2, w2, #AtoF  
dec9:       strb    w2, [x0], #1    
            
            // Process nibble 8:
            
            lsr     x2, x1, #32
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec8                 
            add     w2, w2, #AtoF  
dec8:       strb    w2, [x0], #1    
            
            
// Entry point for wtobuf
//
// wtobuf
//
// Convert a word to a string of 8 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          9 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3

wtobuf:
            // Process nibble 7:
            
            lsr     x2, x1, #28 // See comments for nibble 15
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec7                
            add     w2, w2, #AtoF  
dec7:       strb    w2, [x0], #1    
            
            // Process nibble 6:
            
            lsr     x2, x1, #24
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec6                
            add     w2, w2, #AtoF  
dec6:       strb    w2, [x0], #1    
            
            // Process nibble 5:
            
            lsr     x2, x1, #20
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec5                
            add     w2, w2, #AtoF  
dec5:       strb    w2, [x0], #1    
            
            // Process nibble 4:
            
            lsr     x2, x1, #16
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    
            cmp     w2, #'9'        
            bls     dec4                
            add     w2, w2, #AtoF  
dec4:       strb    w2, [x0], #1    
            
// Entry point for htobuf:
//
// htobuf
//
// Convert a halfword to a string of 4 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          5 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3

htobuf:
            // Process nibble 3:
                        
            lsr     x2, x1, #12 // See comments for nibble 15
            and     x2, x2, 0xf
            orr     w2, w2, #'0'   
            cmp     w2, #'9'       
            bls     dec3            
            add     w2, w2, #AtoF 
dec3:       strb    w2, [x0], #1   
            
            // Process nibble 2:
            
            lsr     x2, x1, #8
            and     x2, x2, 0xf
            orr     w2, w2, #'0'   
            cmp     w2, #'9'       
            bls     dec2            
            add     w2, w2, #AtoF 
dec2:       strb    w2, [x0], #1   

// Entry point for btobuf:
//
// btobuf
//
// Convert a byte to a string of 2 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          3 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3
            
            // Process nibble 1:
            
btobuf:
            lsr     x2, x1, #4  // See comments for nibble 15
            and     x2, x2, 0xf
            orr     w2, w2, #'0'   
            cmp     w2, #'9'       
            bls     dec1                
            add     w2, w2, #AtoF 
dec1:       strb    w2, [x0], #1   
            
            // Process LO nibble:
            
            and     x2, x1, 0xf
            orr     x2, x2, #'0'   
            cmp     w2, #'9'       
            bls     dec0                
            add     w2, w2, #AtoF 
dec0:       strb    w2, [x0], #1   
            
            strb    wzr, [x0]       // Zero-terminate
            ret
            endp    dtobuf


// qtoStr-
//
// Inputs:
//
//  X0-     pointer to buffer that will hold the result
//          (must allocate at least 17 bytes for buffer)
//  X2:X1-  value to print
//
// Outputs:
//
//  Buffer pointed at by X0 receives the 32-character
//  conversion of the dword value in X2:X1 to a hexadecimal string
//
//  Preserves all registers.

            proc    qtoStr
            
            stp     x2, x3, [sp, #-16]!
            stp     x0, lr, [sp, #-16]!
            str     x1, [sp, #-16]!     // Save for later
            
            mov     x1, x2              // Convert HO dword first
            bl      dtobuf
            ldr     x1, [sp], #16       // Restore X1 value
            bl      dtobuf
                        
            // Restore registers and return:
            
            ldp     x0, lr, [sp], #16
            ldp     x2, x3, [sp], #16
            ret
            endp    qtoStr


// Utility function to print qwords (passed in X1:X0):

pqStr:      wastr   "Qword=%s\n"

            proc    pQword
            
            locals  pq
            qword   pq.saveX0X1
            byte    pq.buffer, 32
            byte    pq.stkSpace, 64
            endl    pq
            
            enter   pq.size
            stp     x0, x1, [fp, #pq.saveX0X1]
            
            mov     x2, x1
            mov     x1, x0
            add     x0, fp, #pq.buffer  // lea x0, stkSpace
            bl      qtoStr      
            
            lea     x0, pqStr
            add     x1, fp, #pq.buffer
            mstr    x1, [sp]
            bl      printf
            
            ldp     x0, x1, [fp, #pq.saveX0X1]
            leave
            endp    pQword           

            
            


// Here is the "asmMain" function.

        
            proc    asmMain, public
            
            // Local storage:
            
            locals  am                  // Preserve the X20
            dword   saveX20             // register
            byte    stackspace, 64      
            endl    am                  
            
            enter   am.size             // Create activation record
            str     x20, [fp, #saveX20] // Preserve X20
                        
            ldr     x0, =0x0123456789abcdef
            ldr     x1, =0xfedcba9876543210
            bl      pQword
                        
            ldr     x20, [fp, #saveX20] // Restore X20
            leave
            ret
        
            endp    asmMain

