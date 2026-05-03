// Listing 2-4
//
// Demonstrate packed data types

#include "aoaa.inc"

			.equ	NULL, 0			// Error code
			.equ	maxLen, 256		// Max input line size


			.data
			
saveLRMain:	.dword	0
saveLRRN:	.dword	0

ttlStr:     .asciz	"Listing 2-4"
moPrompt:   .asciz	"Enter current month: "
dayPrompt:  .asciz	"Enter current day: "

yearPrompt: .ascii	"Enter current year "
            .asciz	"(last 2 digits only): "
           
packed:     .ascii	"Packed date is %04x = "
			.asciz  "%02d/%02d/%02d\n"
			
theDate:    .asciz	"The date is %02d/%02d/%02d\n"
           
badDayStr:  .ascii	"Bad day value was entered "
            .asciz	"(expected 1-31)\n"
           
badMonthStr: .ascii	"Bad month value was entered "
             .asciz	"(expected 1-12)\n"
             
badYearStr:  .ascii	"Bad year value was entered "
             .asciz	"(expected 00-99)\n"


// These need extra padding so they can be printed
// as integers. They're really byte (and word) values

month:       .dword   0
day:         .dword   0
year:        .dword   0
date:        .dword   0

m:       	 .dword   0
d:         	 .dword   0
y:        	 .dword   0

input:       .fill    maxLen, 0

            .text
            .align	2		// Word-align code
            .extern	printf
            .extern	readLine
            .extern	strtol

// Return program title to C++ program:

            .global	getTitle
getTitle:
            lea 	x0, ttlStr
            ret


// Here's a user-written function that reads a numeric value from the
// user
// 
// int readNum( char *prompt );
// 
// A pointer to a string containing a prompt message is passed in the
// X0 register.
// 
// This procedure prints the prompt, reads an input string from the
// user, then converts the input string to an integer and returns the
// integer value in X0.

readNum:
			lea		x1, saveLRRN
			str		lr, [x1]		// save return address

// Must set up stack properly (using this "magic" instruction) before
// we can call any C/C++ functions:

            sub     sp, sp, #64
        
// Print the prompt message. Note that the prompt message was passed to
// this procedure in X0, we're just passing it on to printf:

            bl		printf

// Set up arguments for readLine and read a line of text from the user.
// Note that readLine returns NULL (0) in RAX if there was an error.

            lea     x0, input
            mov     x1, #maxLen
            bl    	readLine
        
// Test for a bad input string:

            cmp     x0, #NULL
            beq     badInput
        
// Okay, good input at this point, try converting the string to an
// integer by calling strtol. The strtol function returns zero if 
// there was an error, but zero is a perfectly fine return result, 
// so we ignore errors.

            lea     x0, input       //Ptr to string
            mov		x1, #NULL		//No end string pointer
            mov		x2, #10			//Decimal conversion
            bl		strtol          //Convert to integer
        
badInput:
            add     sp, sp, #64     //Undo stack setup
            lea		x1, saveLRRN	//Restore return address
            ldr		lr, [x1]
            ret
        
// Here is the "asmMain" function.

        
            .global	asmMain
asmMain:
            sub     sp, sp, #64		//Magic instruction
            lea		x0, saveLRMain
            str		lr, [x0]

// Read the date from the user. Begin by reading the month:

            lea     x0, moPrompt
            bl		readNum
        
// Verify the month is in the range 1..12:
        
            cmp     x0, #1
            blo     badMonth
            cmp     x0, #12
            bhi     badMonth
        
//Good month, save it for now
        
        	lea		x1, month
        	strb	w0, [x1]	//1..12 fits in a byte
        
// Read the day:

            lea     x0, dayPrompt
            bl      readNum
        
// We'll be lazy here and only verify only  that the day is in the range
// 1..31.
        
            cmp     x0, #1
            blo     badDay
            cmp     x0, #31
            bhi     badDay
        
//Good day, save it for now
        
        	lea		x1, day
        	strb	w0, [x1]	//1..31 fits in a byte
        
// Read the year

            lea     x0, yearPrompt
            bl      readNum
        
// Verify that the year is in the range 0..99.
        
            cmp     x0, #0
            blo     badYear
            cmp     x0, #99
            bhi     badYear
        
//Good year, save it for now
        
        	lea		x1, year
        	strb	w0, [x1] //0..99 fits in a byte
        
// Pack the data into the following bits:
//
//  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
//   m  m  m  m  d  d  d  d  d  y  y  y  y  y  y  y

			lea		x0, month
			ldrb	w1, [x0]
			lsl		w1, w1, #5
			
			lea		x0, day
			ldrb	w2, [x0]
			orr		w1, w1, w2
			lsl		w1, w1, #7
			
			lea		x0, year
			ldrb	w2, [x0]
			orr		w1, w1, w2
			
			lea		x0, date
			strh	w1, [x0]

        
// Print the packed date:

            lea     x0, packed
            vparm2	date
            vparm3	month
            vparm4	day
            vparm5	year
            bl      printf
        
// Unpack the date and print it:

			lea		x0, date
			ldrh	w1, [x0]
			
			// Extract month:
			
			lsr		w2, w1, #12
			lea		x0, m
			strb	w2, [x0]
			
			// Extract day:
			
			lsr		w3, w1, #7
			and		w3, w3, #0x1f
			lea		x0, d
			strb	w3, [x0]

			// Extract year:
			
			and		w1, w1, #0x7f
			lea		x0, y
			strb	w1, [x0]

            lea     x0, theDate
            vparm2	m
            vparm3	d
            vparm4	y
            bl      printf 
        
            b.al   	allDone
                
// Come down here if a bad day was entered:

badDay:
            lea     x0, badDayStr
            bl      printf
            b.al    allDone
        

// Come down here if a bad month was entered:

badMonth:
            lea     x0, badMonthStr
            bl      printf
            b.al    allDone
        
// Come here if a bad year was entered:

badYear:
            lea     x0, badYearStr
            bl      printf  

allDone:       
            add     sp, sp, #64
            lea		x0, saveLRMain
            ldr		lr, [x0]
            ret     //Returns to caller


