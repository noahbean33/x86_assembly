// Listing12-2.S
//
// Demonstration of bit string searching

        #include    "aoaa.inc"



           
#define sb	x28                         

        .data
iFmtStr:
        .asciz  "X1=%x\n"
        
iFmtStr2:
        .asciz  "i=%d, j=%d\n"
        
		.align	3
i:      .dword  1
j:      .dword  5

        
        .text
        .pool
ttlStr: wastr  "Listing 12-2"

var0:   .asciz   "Hello"

                
        .align  2
        
        
        proc    getTitle, public
        lea     x0, ttlStr
        ret
        endp    getTitle
                      
        
        proc    asmMain, public
        
        locals  am
        word    pattern
        word    source
        word    mask
        byte    am.stk, 64
        endl    am
        
        enter   am.size

		
		mov		x2, #0x1
		mov		x1, #0
		ands	x0, x1, x2, lsr #1
		adc		w1, wzr, wzr
		
		mov		sb, x0
		
		lea		x0, iFmtStr
		mstr	x1, [sp]
		bl		printf		
        

Done:               
        leave                       // Return to caller
        endp    asmMain 