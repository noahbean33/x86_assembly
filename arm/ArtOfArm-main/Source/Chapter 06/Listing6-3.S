// Listing6-3
//
//  Demonstrate calling various C stdlib
//  math functions.

#include    "aoaa.inc"
        


        .text
        .extern sin     //C stdlib functions
        .extern cos     // this program calls
        .extern tan
        
        .pool
ttlStr: wastr   "Listing 6-3"

// Format strings for each of the outputs:

piStr:  wastr   "%s(pi) = %20.14e\n"
pi2Str: wastr   "%s(pi/2) = %20.14e\n"
pi4Str: wastr   "%s(pi/4) = %20.14e\n"
pi8Str: wastr   "%s(pi/8) = %20.14e\n\n"

// Function names (printed as %s argument
// in the format strings):

sinStr: wastr   "sin"
cosStr: wastr   "cos"
tanStr: wastr   "tan"


// Sample values to print for each
// of the functions:

pi:     .double 3.141592653588979
pi2:    .double 1.5707963267949
pi4:    .double 0.7853981639745
pi8:    .double 0.39269908169872


// getTitle-
// Return pointer to program title
// to the C++ code.
        
        proc    getTitle, public
        lea     x0, ttlStr
        ret
        endp    getTitle
        

// Trampolines to the C stdlib math functions.
// These are necessary because LEA can't take
// the address of a function that could be
// very far away (as the dynamic libraries
// probably are).
// 
// Note: Must use real "b" instruction here
// rather than "b.al" because external
// functions are likely out of range.
        
        proc    sinVeneer
        b       sin
        endp    sinVeneer
        
        proc    cosVeneer
        b       cos
        endp    cosVeneer
        
        proc    tanVeneer
        b       tan
        endp    tanVeneer
        
// doPi( char *X0, func x1 )
//
// X0   contains the address of a function
//      that accepts a single double and
//      returns a double result.
// X1   contains the address of a string
//      specifying the function name.
//
// This function calls the specified function
// passing PI divided by 1, 2, 4, and 8 and
// then prints the result that comes back.

        proc    doPi
        locals  dp
        dword   dp.savex1
        dword   dp.savex0
        dword   dp.savex19
        byte    dp.stackSpace, 64
        endl    dp 
        
        // Set up activation record and save register values:
        
        enter   dp.size
        stp     x0, x1, [fp, #dp.savex0] //X1->savex1, too
        str     x19, [fp, #dp.savex19]   //Preserve non-volatile
        
        mov     x19, x0         //Keep address in non-volatile
        
        // Call the function for various values
        // of pi/n:
        
        ldr     d0, pi
        blr     x19             //Call function
        mstr    d0, [sp, #8]    //Save func result as parm
        ldr     x1, [fp, #dp.savex1]
        mstr    x1, [sp]
        lea     x0, piStr
        bl      printf

        
        ldr     d0, pi2
        blr     x19             //Call function
        mstr    d0, [sp, #8]
        lea     x0, piStr
        ldr     x1, [fp, #dp.savex1]
        mstr    x1, [sp]
        lea     x0, pi2Str
        bl      printf
        
        ldr     d0, pi4
        blr     x19             //Call function
        mstr    d0, [sp, #8]
        lea     x0, piStr
        ldr     x1, [fp, #dp.savex1]
        mstr    x1, [sp]
        lea     x0, pi4Str
        bl      printf
        
        ldr     d0, pi8
        blr     x19             //Call function
        mstr    d0, [sp, #8]
        lea     x0, piStr
        ldr     x1, [fp, #dp.savex1]
        mstr    x1, [sp]
        lea     x0, pi8Str
        bl      printf
        
        
        // Restore non-volatile register
        // and return:
        
        ldr     x19, [fp, #dp.savex19]
        leave
        endp    doPi       

               
/////////////////////////////////////////////////////////
//        
// Here's the asmMain procedure:

        proc    asmMain, public
        enter   64              //Generic entry

        // Load X0 with the address
        // of the veneer (trampoline) function
        // that calls the C stdlib math function,
        // load X1 with the function's name,
        // then call doPi to call the function
        // and print the results.
        
        lea     x0, sinVeneer   //SIN(x) output
        lea     x1, sinStr
        bl      doPi

        lea     x0, cosVeneer   //COS(x) output
        lea     x1, cosStr
        bl      doPi

        lea     x0, tanVeneer   //TAN(x) output
        lea     x1, tanStr
        bl      doPi
        
        leave                   //Return to C/C++ code
        endp    asmMain 
        
