// files.S            
//
// File I/O functions:

            #include    "../aoaa.inc"
            #include    "files.inc"
               
            .code
            .align  2

////////////////////////////////////////////
//
// file.write-
//
//  Write data to a file handle.
//
// x0- file handle
// x1- pointer to buffer to write
// x2- length of buffer to write
//
// Returns:
//
// x0- Number of bytes actually written
//      or -1 if there was an error
            
            proc    file.write, public
            
            locals  fw_locals
            qword   fw_locals.saveX0
            byte    fw_locals.volSave, volatile_save.size
            byte    fw_locals.stkspace, 64
            dword   fw_locals.fpSave
            endl    fw_locals
            
            enter   fw_locals.size
            
            // Preserve all the volatile registers because
            // the OS API write function might modify them.
            //
            // Note: because w_locals.volSave is at the
            // bottom of the activation record, SP just
            // happens to be pointing at it right now.
            // Use it to temporarily save FP so we can
            // pass the address of w_locals.volSave to
            // saveVolatile in the FP register.
            
            str     fp, [sp]    //fw_locals.fpSave
            add     fp, fp, #fw_locals.volSave
            bl      saveVolatile
            ldr     fp, [sp]    //Restore FP
            
            // Okay, now do the write operation (note that
            // the write arguments are already sitting
            // in X0, X1, and X2 upon entry into this
            // function).
            
            bl		_write
            
            // Check for error return code:
            
            file.checkError         
            
            // Restore the volatile registers, except
            // X0 (because we return the function
            // result in X0):
            
            str     x0, [fp, #fw_locals.saveX0] //Return value
            str     fp, [sp]    //w_locals.fpSave
            add     fp, fp, #fw_locals.volSave
            bl      restoreVolatile
            ldr     fp, [sp]    //Restore FP
            ldr     x0, [fp, #fw_locals.saveX0]
            leave
            endp    file.write
                        

////////////////////////////////////////////////////////////
//
// file.read-
//
//  Read data from a file handle.
//
// X0- file handle
// X1- pointer to buffer receive data
// X2- length of data to read
//
// Returns:
//
// X0- Number of bytes actually read
//      or negative value if there was an error
            
            proc    file.read, public
            
            locals  fr_locals
            qword   fr_locals.saveX0
            byte    fr_locals.volSave, volatile_save.size
            byte    fr_locals.stkspace, 64
            dword   fr_locals.fpSave
            endl    fr_locals
            
            enter   fr_locals.size
            
            // Preserve all the volatile registers because
            // the OS API read function might modify them.
            //
            // Note: because w_locals.volSave is at the
            // bottom of the activation record, SP just
            // happens to be pointing at it right now.
            // Use it to temporarily save FP so we can
            // pass the address of w_locals.volSave to
            // saveVolatile in the FP register.
            
            str     fp, [sp]    //fr_locals.fpSave
            add     fp, fp, #fr_locals.volSave
            bl      saveVolatile
            ldr     fp, [sp]    //Restore FP
            
            // Okay, now do the read operation (note that
            // the sys_Read arguments are already sitting
            // in X0, X1, and X2 upon entry into this
            // function).
            
            bl		_read
            
            // Check for error return code:
            
            file.checkError         
            
            // Restore the volatile registers, except
            // X0 (because we return the function
            // result in X0):
            
            str     x0, [fp, #fr_locals.saveX0] //Return value
            str     fp, [sp]    //fr_locals.fpSave
            add     fp, fp, #fr_locals.volSave
            bl      restoreVolatile
            ldr     fp, [sp]    //Restore FP
            ldr     x0, [fp, #fr_locals.saveX0]
            leave
            endp    file.read

////////////////////////////////////////////////////////////
//
// file.open-
//
//  Open existing file for reading or writing:
//
// X0- Pointer to pathname string (zero terminated)
// X1- File access flags
//      (O_RDONLY, O_WRONLY, or O_RDWR)
//
// Returns:
//
// X0- Handle of open file (or negative value if there
//     was an error opening the file).

            proc    file.open, public
            
            locals  fo_locals
            qword   fo_locals.saveX0
            byte    fo_locals.volSave, volatile_save.size
            byte    fo_locals.stkspace, 64
            dword   fo_locals.fpSave
            endl    fo_locals
            
            enter   fo_locals.size
            
            // Preserve all the volatile registers because
            // the OS API open function might modify them.
            
            str     fp, [sp]    //fo_locals.fpSave
            add     fp, fp, #fo_locals.volSave
            bl      saveVolatile
            ldr     fp, [sp]    //Restore FP
            
            // Call the OS API open function.
            
            mov     x2, x1
            mov     x1, x0
            mov     x0, #AT_FDCWD
            mov     x3, #S_RDWR     //mode, usually ignored
            bl		_openat
            
            // Check for error return code:
            
            file.checkError         
            
            // Restore the volatile registers, except
            // X0 (because we return the function
            // result in X0):
            
            str     x0, [fp, #fo_locals.saveX0] //Return value
            str     fp, [sp]    //fo_locals.fpSave
            add     fp, fp, #fo_locals.volSave
            bl      restoreVolatile
            ldr     fp, [sp]    //Restore FP
            ldr     x0, [fp, #fo_locals.saveX0]
            leave
            endp    file.open



////////////////////////////////////////////////////////////
//
// file.openNew-
//
//  Creates a new file and opens it for writing:
//
// X0- Pointer to filename string (zero terminated)
//
// Returns:
//
// X0- Handle of open file (or negative if there
//      was an error creating the file).


            proc    file.openNew, public
            
            locals  fon_locals
            qword   fon_locals.saveX0
            byte    fon_locals.volSave, volatile_save.size
            byte    fon_locals.stkspace, 64
            dword   fon_locals.fpSave
            endl    fon_locals
            
            enter   fon_locals.size
            
            // Preserve all the volatile registers because
            // the OS API open function might modify them.
            
            str     fp, [sp]    //fon_locals.fpSave
            add     fp, fp, #fon_locals.volSave
            bl      saveVolatile
            ldr     fp, [sp]    //Restore FP
            
            // Call the OS API open function.
            
            mov     x2, #O_CREAT+O_WRONLY+O_EXCL
            mov     x1, x0
            mov     x0, #AT_FDCWD
            mov     x3, #S_RDWR //User/Group has RW perms
            bl		_openat
            
            // Check for error return code:
            
            file.checkError         
            
            
            // Restore the volatile registers, except
            // X0 (because we return the function
            // result in X0):
            
            str     x0, [fp, #fon_locals.saveX0]    //Return value
            str     fp, [sp]    //w_locals.fpSave
            add     fp, fp, #fon_locals.volSave
            bl      restoreVolatile
            ldr     fp, [sp]    //Restore FP
            ldr     x0, [fp, #fon_locals.saveX0]
            leave
            endp    file.openNew




////////////////////////////////////////////////////////////
//
// file.close-
//
// Closes a file specified by a file handle.
//
// RAX- Handle of file to close.

            proc    file.close, public
            
            locals  fc_locals
            qword   fc_locals.saveX0
            byte    fc_locals.volSave, volatile_save.size
            byte    fc_locals.stkspace, 64
            dword   fc_locals.fpSave
            endl    fc_locals
            
            enter   fc_locals.size
            
            // Preserve all the volatile registers because
            // the OS API open function might modify them.
            
            str     fp, [sp]    //fc_locals.fpSave
            add     fp, fp, #fc_locals.volSave
            bl      saveVolatile
            ldr     fp, [sp]    //Restore FP
            
            // Call the OS API close function (handle is
            // already in X0).
            
            bl		_close
            
            // Check for error return code:
            
            file.checkError         
                        
            // Restore the volatile registers, except
            // X0 (because we return the function
            // result in X0):
            
            str     x0, [fp, #fc_locals.saveX0] //Return value
            str     fp, [sp]    //w_locals.fpSave
            add     fp, fp, #fc_locals.volSave
            bl      restoreVolatile
            ldr     fp, [sp]    //Restore FP
            ldr     x0, [fp, #fc_locals.saveX0]
            leave
            endp    file.close




