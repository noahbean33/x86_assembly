// listing 1-3:
// A simple MASM module that contains
// an empty function to be called by
// the C++ code in listing 1-2.

        .text
        
// Here is the "asmFunc" function.

        .global	_asmFunc
        .align	2
_asmFunc:

// Empty function just returns to C++ code
        
        ret     //Returns to caller
        
