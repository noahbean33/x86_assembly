// Listing 7-3
//
// Initializing qword values with the
// addresses of statement labels.

#include "aoaa.inc"

            .data
			.align   3   // dword align data
lblsInProc: .dword   globalLbl1, globalLbl2  //From procWLabels
        
            .code

//procWLabels-
// Just a procedure containing private (lexically scoped)
// and global symbols. This really isn't an executable
// procedure.
 
             proc    procWLabels

globalLbl1:  b.al    globalLbl2
globalLbl2: 
             ret
			 endp    procWLabels
			 
             .pool
			 .align  3   // dword align data
dataInCode:  .dword   globalLbl2, globalLbl1
