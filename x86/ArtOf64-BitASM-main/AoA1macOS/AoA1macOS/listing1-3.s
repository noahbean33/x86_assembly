# listing 1-3:
# A simple Gas module that contains an empty function to be 
# called by the C++ code in listing 1-2.
#
# gcc listing1-2.cpp listing1-3.s

            .text
            .global _asmFunc
        
        
# Here is the "asmFunc" function.

_asmFunc:

# Empty function just returns to C++ code
        
        ret     #returns to caller


