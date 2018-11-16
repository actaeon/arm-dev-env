@ ECE 371 Design Project #1
@ Part Two
@ 
@ This program will iterate over an array of 8-bit simulated temperature values
@ ranging in value from 0 to 125 degrees Fahrenheit and finds their average.
@ The algorithm does an integer divide on the sum by right-shifting by 4 (16)
@ and adding the carry flag back in for a round-up.
@
@ Additionally, a subroutine is called to determine the minimum and maximum
@ values in the array, and returns those 
@ 
@ The min-max subroutine of this file can be included in a wrapper asm file and then
@ compiled to object code for linkage with a high-level program for unit testing
@ 
@ Bill Green
@ Portland State University
@ greenbil@pdx.edu

.ifndef TESTING                                   @  For testing, we don't need the startup code
                                                  @    or the averaging routine so don't include for testing.
                                                  @    Because the routine must be callable from a high-level
                                                  @    language. Also it must save state and use the calling
                                                  @    convention. So this file will be included in a wrapper
                                                  @    with the unnecessary bits commented out               
.text                                             @  Start of text section                 
                                                  @                   
.global _start                                    @  Define our _start global                 
.global MinMax                                    @  Constant that holds the number of timeslices we'                 
.equ    TEMP_COUNT, 0x10                          @  Constant that holds the number of timeslices we're dealing with                 
                                                  @    - 16 in this case.                  
@                                                 @                   
@ main                                            @                   
@                                                 @                   
_start:           LDR   R4,   =Fahrenheit_Temps   @  Entrypoint                 
                  LDR   R5,   =Temp_Avg           @  Load R5 with the location of the average temps result                 
                  LDR   R6,   =Temp_Min           @  Load R6 with the location of the minimum temp result                 
                  LDR   R7,   =Temp_Max           @  Load R7 with the location of the maximum temp reuslt                 
                  LDR   R8,   =TEMP_COUNT         @  Load R8 with the length of the temperature timeslice array                 
                  MOV   R10,   #0                 @  Initialize R10 as accumulator                 
avg_next:         LDRB  R9,   [R4], #0x01         @  Load R9 with next value from temps array                 
                  ADD   R10,   R10, R9            @  Add to accumulator
                  SUBS  R8,   #0x01               @  Decrement counter                 
                  BNE   avg_next                  @  Do it again if not done                 
                  MOVS  R10,   R10, LSR #4        @  integer divide by 16 using LSL. MSB of shifted
                                                  @    off values ends up in carry flag. If this bit is a one, then the value
                                                  @    of the remainder is at least .5. if 0 then remainder is < .5
                  ADC   R10,   #0                 @  Add the carry                 
                  STRB  R10,   [R5]               @  Store the rounded average to mem                 
                  LDR   R0,   =Fahrenheit_Temps   @  reset R0 to start of temps array for passing to subroutine
                  LDR   R1, =TEMP_COUNT           @  load R1 with length of array for passing to subroutine
                  BL    MinMax                    @  branch to MinMax subroutine                 
                  STRB  R0,   [R6]                @  Store returned min temp in mem                 
                  STRB  R1,   [R7]                @  Store returned max temp in mem                 
                  NOP                             @  Convenient spot for breakpoint                 
.endif

@                                                                    
@ MinMax subroutine
@
@ Purpose:
@   This subroutine will iterate over an array of 8-bit values
@   and return the minimum and maximum values encountered.
@ 
@ Input Parameters:
@   R0 = address of first element in array to be processed
@   R1 = length of array
@ 
@ Return values:
@   R0 = the minimum value in the array
@   R1 = the maximum value in the array                                                  
@                                                                    

.include "../lib/min_max.s"
                                                  @                   
.ifndef TESTING                                   @ Again, if we're testing we're including just the core routine
                                                  @ in a wrapper file, so we don't care about the data section                  
.data                                             @                   
STACK:            .rept 256                       @ For production, use 256-byte stack                  
                  .byte 0x00                      @                   
                  .endr                           @                   
                                                  @ Initialize temps array with sample values
Fahrenheit_Temps: .byte 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10@                   
Temp_Avg:         .byte 0x00                      @ Initialize location for calculated average                  
Temp_Min:         .byte 0x00                      @ Initialize location for calculated minimum                                    
Temp_Max:         .byte 0x00                      @ Initialize location for calculated maximum                                    
                                                  @                   
.endif                                            @                   

.end                                              @                   
