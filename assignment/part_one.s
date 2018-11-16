@ ECE 371 Design Project #1
@ Part One
@ 
@ This program will iterate over an array of 8-bit simulated temperature values
@ ranging in value from 0 to 125 degrees Fahrenheit and finds their average.
@ The algorithm does an integer divide on the sum by right-shifting by 4 (16)
@ and adding the carry flag back in for a round-up
@ 
@ The main routine of this file can be included in a wrapper asm file and then
@ compiled to object code for linkage with a high-level program for unit testing
@ 
@ Bill Green
@ Portland State University
@ greenbil@pdx.edu

.text                                             @  Start of text section                 
                                                  @                   
.global _start                                    @  Define our _start global                 
.equ    TEMP_COUNT, 0x10                          @  Constant that holds the number of timeslices we're dealing with
                                                  @    - 16 in this case.                 
                                                  @                   
_start:           LDR   R0,   =Fahrenheit_Temps   @  Entrypoint                 
                  LDR   R1,   =Temp_Avg           @  Load R1 with addr of our temp timeslices                 
                  LDR   R6,   =TEMP_COUNT         @  Load R6 counter with length of timeslice array                 
                  MOV   R7,   #0                  @  Initialize R7 as accumulator                 
                                                  @                   

.include "../lib/avg_temps.s"
                                                  @                   
.data                                             @                   
                                                  @  Fahrenheit_Temps is our array of temperature timeslice values                
Fahrenheit_Temps: .byte 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10@                   
Temp_Avg:         .byte 0x00                      @  Holds result of average operation                 
                                                  @                   
.end                                              @                   
