; Listing 2-4
;
; Demonstrate packed data types
;
;
; c:>build listing2-4
; c:>listing2-4


	default rel
	bits	64

nl      	equ	10  ;ASCII code for newline
NULL    	equ	0
nl      	equ	10  ;ASCII code for newline
maxLen  	equ	256


; New data declaration section.
; .const holds data values for read-only constants

	section .const
ttlStr      db    	'Listing 2-4', 0
moPrompt    db    	'Enter current month: ', 0
dayPrompt   db    	'Enter current day: ', 0
yearPrompt  db    	'Enter current year '
            db    	'(last 2 digits only): ', 0
           
packed      db    	'Packed date is %04x', nl, 0
theDate     db    	'The date is %02d/%02d/%02d'
            db    	nl, 0
           
badDayStr   db    	'Bad day value was entered '
            db    	'(expected 1-31)', nl, 0
           
badMonthStr db    	'Bad month value was entered '
            db    	'(expected 1-12)', nl, 0
badYearStr  db    	'Bad year value was entered '
            db    	'(expected 00-99)', nl, 0



	section .data
month       db    	0
day         db    	0
year        db    	0
date        db    	0

input       db    	maxLen dup (0)

	section .text
            extern 	printf
            extern 	readLine
            extern 	atoi

; Return program title to C++ program:

            global	getTitle
getTitle:
            lea 	rax, [ttlStr]
            ret



; Here's a user-written function that reads a numeric value from the
; user
; 
; int readNum( char *prompt );
; 
; A pointer to a string containing a prompt message is passed in the
; RCX register.
; 
; This procedure prints the prompt, reads an input string from the
; user, then converts the input string to an integer and returns the
; integer value in RAX.

readNum:

; Must set up stack properly (using this "magic" instruction) before
; we can call any C/C++ functions:

            sub     rsp, 56
        
; Print the prompt message. Note that the prompt message was passed to
; this procedure in RCX, we're just passing it on to printf:

            call    printf

; Set up arguments for readLine and read a line of text from the user.
; Note that readLine returns NULL (0) in RAX if there was an error.

            lea     rcx, [input]
            mov     rdx, maxLen
            call    readLine
        
; Test for a bad input string:

            cmp     rax, NULL
            je      badInput
        
; Okay, good input at this point, try converting the string to an
; integer by calling atoi. The atoi function returns zero if there was
; an error, but zero is a perfectly fine return result, so we ignore
; errors.

            lea     rcx, [input]    ;Ptr to string
            call    atoi            ;Convert to integer
        
badInput:
            add     rsp, 56         ;Undo stack setup
            ret

        
; Here is the "asmMain" function.

        
            global	asmMain
asmMain:
            sub     rsp, 56

; Read the date from the user. Begin by reading the month:

            lea     rcx, [moPrompt]
            call    readNum
        
; Verify the month is in the range 1..12:
        
            cmp     rax, 1
            jl      badMonth
            cmp     rax, 12
            jg      badMonth
        
;Good month, save it for now
        
            mov     [month], al ;1..12 fits in a byte
        
; Read the day:

            lea     rcx, [dayPrompt]
            call    readNum
        
; We'll be lazy here and only verify that the day is in the range
; 1..31.
        
            cmp     rax, 1
            jl      badDay
            cmp     rax, 31
            jg      badDay
        
;Good day, save it for now
        
            mov     [day], al ;1..31 fits in a byte
        
; Read the year

            lea     rcx, [yearPrompt]
            call    readNum
        
; Verify that the year is in the range 0..99.
        
            cmp     rax, 0
            jl      badYear
            cmp     rax, 99
            jg      badYear
        
;Good day, save it for now
        
            mov     [year], al ;0..99 fits in a byte
        
; Pack the data into the following bits:
;
;  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
;   m  m  m  m  d  d  d  d  d  y  y  y  y  y  y  y

            movzx   ax, [month]
            shl     ax, 5
            or      al, [day]
            shl     ax, 7
            or      al, [year]
            mov     [date], ax
        
; Print the packed date:

            lea     rcx, [packed]
            movzx   rdx, word [date]
            call    printf
        
; Unpack the date and print it:

            movzx   rdx, word [date]
            mov     r9, rdx
            and     r9, 7fh         ;Keep LO 7 bits (year)
            shr     rdx, 7          ;Get day in position
            mov     r8, rdx
            and     r8, 1fh         ;Keep LO 5 bits
            shr     rdx, 5          ;Get month in position
            lea     rcx, [theDate]
            call    printf 
        
            jmp     allDone
                
; Come down here if a bad day was entered:

badDay:
            lea     rcx, [badDayStr]
            call    printf
            jmp     allDone
        

; Come down here if a bad month was entered:

badMonth:
            lea     rcx, [badMonthStr]
            call    printf
            jmp     allDone
        
; Come here if a bad year was entered:

badYear:
            lea     rcx, [badYearStr]
            call    printf  

allDone:       
            add     rsp, 56
            ret     ;Returns to caller

