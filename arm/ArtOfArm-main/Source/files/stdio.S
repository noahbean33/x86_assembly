// stdio.S            
//
// Standard input and standard output functions:

            #include    "../aoaa.inc"
            #include    "files.inc"
            #include    <sys/syscall.h>
               
            .code
            .align  2
                            
            
////////////////////////////////////////////////////////////////
//
// stdout.puts-
//
// Outputs a zero-terminated string to standard output device.
//
// X0-      Address of string to print to standard output.

            proc    stdout.puts, public
            
            locals  lcl_puts
            qword   lcl_puts.saveX0X1
            dword   lcl_puts.saveX2
            byte    lcl_puts.stkSpace, 64
            endl    lcl_puts
            
            enter   lcl_puts.size
            
            stp     x0, x1, [fp, #lcl_puts.saveX0X1]
            str     x2,     [fp, #lcl_puts.saveX2]
            
            mov     x1, x0

// Compute the length of the string:
            
lenLp:      ldrb    w2, [x1], #1
            cbnz    w2, lenLp
            sub     x2, x1, x0  //Compute length
            
            //Call file_write to print the string:
            
            mov     x1, x0
            mov     x0, #stdout
            bl      file.write
            
            // Return to caller:
             
            ldr     x2,     [fp, #lcl_puts.saveX2]
            ldp     x0, x1, [fp, #lcl_puts.saveX0X1] 
            leave
            endp    stdout.puts


////////////////////////////////////////////////////////////////
//
// stdout.newLn-
//
// Outputs a newline sequence to the standard output device:

stdout.nl:  .ascii  "\n"
nl.len      =       .-stdout.nl
            .byte   0
            .align  2

            proc    stdout.newLn, public
            
            
            locals  lcl_nl
            qword   lcl_nl.saveX0X1
            dword   lcl_nl.saveX2
            byte    lcl_nl.stkSpace, 64
            endl    lcl_nl
            
            enter   lcl_nl.size
            stp     x0, x1, [fp, #lcl_nl.saveX0X1]
            str     x2,     [fp, #lcl_nl.saveX2]

            lea     x1, stdout.nl
            mov     x2, #nl.len
            mov     x0, stdout
            bl      file.write
            
            ldr     x2,     [fp, #lcl_nl.saveX2]
            ldp     x0, x1, [fp, #lcl_nl.saveX0X1] 
            leave
            endp    stdout.newLn
            

////////////////////////////////////////////////////////////
//
// stdin.read-
//
// Reads data from the standard input.
//
// X0- Buffer to receive data
// X1- Buffer count (note that data input will
//      stop on a newline character if that
//      comes along before X1 characters have
//      been read).
//
// Returns:
//
// X0- negative value if error, bytes read if successful.       

            proc    stdin.read, public
            
            locals  sr_locals
            qword   sr_locals.saveX1X2
            byte    sr_locals.stkspace, 64
            dword   sr_locals.fpSave
            endl    sr_locals
            
            enter   sr_locals.size
            stp     x1, x2, [fp, #sr_locals.saveX1X2]
            
                        
            // Call the OS API read function.
            
            mov     svcReg, #sys_Read
            mov     x2, x1
            mov     x1, x0
            mov     x0, #stdin
            svc     #OSint
            
            file.checkError
            
            ldp     x1, x2, [fp, #sr_locals.saveX1X2]
            leave
            endp    stdin.read



////////////////////////////////////////////////////////////
//
// stdin_getc-
//
// Read a single character from the standard input.
// Returns character in X0 register.

            proc    stdin.getc, public
            
            locals  sgc_locals
            qword   sgc_locals.saveX1X2
            byte    sgc_buf, 16
            byte    sgc_locals.stkspace, 64
            endl    sgc_locals
            
            enter   sgc_locals.size
            stp     x1, x2, [fp, #sgc_locals.saveX1X2]
            
            // Initialize return value to all zeros:
            
            str     xzr, [fp, #sgc_buf]
            
                        
            // Call the OS API read function to read
            // a single character:
            
            mov     svcReg, #sys_Read
            mov     x0, #stdin
            add     x1, fp, #sgc_buf
            mov     x2, #1
            svc     #OSint
            
            file.checkError
            cmp     x0, #0
            bpl     noError
            
            // If there was an error, return the
            // error code in X0 rather than a char:
            
            str     x0, [fp, #sgc_buf]
            
noError:
            ldp     x1, x2, [fp, #sgc_locals.saveX1X2]
            ldr     x0, [fp, #sgc_buf]
            leave
            endp    stdin.getc




////////////////////////////////////////////////////////////
//
// stdin.readln-
// 
// Reads a line of text from the user.
// Automatically processes backspace characters
// (deleting previous characters, as appropriate).
// Line returned from function is zero terminated
// and does not include the ENTER key code (carriage
// return) or line feed.
//
// X0-      Buffer to place line of text read from user.
// X1-      Maximum buffer length
//
// Returns:
//
// X0-      Number of characters read from the user
//           (does not include ENTER key).

            proc    stdin.readln, public
            
            locals  srl_locals
            qword   srl_locals.saveX1X2
            dword   srl_locals.saveX3
            byte    srl_buf, 16
            byte    srl_locals.stkspace, 64
            endl    srl_locals
            
            enter   srl_locals.size
            stp     x1, x2, [fp, #srl_locals.saveX1X2]
            str     x3,     [fp, #srl_locals.saveX3]
            
            mov     x3, x0          //Buf ptr in X3
            mov     x2, #0          //Character count
            cbz     x1, exitRdLn    //Bail if zero chars
            
            sub     x1, x1, #1      //Leave room for 0 byte
readLp:
            bl      stdin.getc      //Read 1 char from stdin
                        
            cmp     w0, wzr         //Check for error
            bmi     exitRdLn

            cmp     w0, #cr         //Check for newline code
            beq     lineDone

            cmp     w0, #lf         //Check for newline code
            beq     lineDone
            
            cmp     w0, #bs         //Handle backspace character
            bne     addChar
            
// If a backspace character came along, remove the previous
// character from the input buffer (assuming there is a
// previous character).

            cmp     x2, #0        //Ignore BS character if no
            beq     readLp        // chars in the buffer
            sub     x2, x2, #1
            b.al    readLp

// If a normal character (that we return to the caller),
// then add the character to the buffer if there is
// room for it (ignore the character if the buffer is full).
            
addChar:    cmp     x2, x1          //See if we're at the
            bhs     readLp          // end of the buffer
            strb    w0, [x3, x2]    //Save char to buffer
            add     x2, x2, #1
            b.al     readLp

// When the user presses the ENTER key (or linefeed) key
// during input, come down here and zero terminate the string.

lineDone:   strb    wzr, [x3, x2]        
            
exitRdLn:   mov     x0, x2          //Return char cnt in X0
            ldp     x1, x2, [fp, #srl_locals.saveX1X2]
            ldr     x3,     [fp, #srl_locals.saveX3]
            leave
            endp    stdin.readln  

                                            

         
