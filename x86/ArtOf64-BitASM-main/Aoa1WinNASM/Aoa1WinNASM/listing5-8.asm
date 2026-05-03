; Listing 5-8
;
; Demonstrate obtaining the address
; of a static variable using offset
; operator.
;
; nasm -Ov -f win64 listing5-8.asm -o listing5-8.obj
; 


	default rel
	bits	64
	

            section	.data
staticVar   dd   	0

            section	.text
            extern	someFunc
            
getAddress:

            mov     rcx, staticVar
            call    someFunc

            ret

