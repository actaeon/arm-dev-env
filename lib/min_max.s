MinMax:           STMFD R13!, {R4-R6, R14}        @ Save the state of the registers on the stack                  
                  MOV   R4,   R1                  @ Pick up the length of timeslice array                   
                  MOV   R5,   R0                  @ Pick up the start of the timeslice array
                  LDRB  R0,   [R5], #0x01         @ Assume the first value in the array is both the                  
                  MOV   R1,   R0                  @   max and min                  
                  SUBS  R4,   #0x01               @ We've essentially done the first iteration by
                                                  @   putting the first value in max and min, so we need
                                                  @   to decrement the count accordingly                   
mm_next:          LDRB  R6,   [R5], #0x01         @ Load the next value for comparison into R6                  
                  CMP   R6,   R0                  @ Compare the new value to the current minimum                  
                  MOVLT R0,   R6                  @ If new value is lower, use it as the new minimum                  
                  CMP   R6,   R1                  @ Compare the new value to the current maximum                  
                  MOVGT R1,   R6                  @ If the new value is higher, use it as the current max                  
                  SUBS  R4,   #0x01               @ decrement the counter                  
                  BNE   mm_next                   @ do it again if not done                  
                  LDMFD R13!, {R4-R6, R14}        @ we're done. R0 now has min, R1 has max, so restore state                  
                  MOV   PC,   R14                 @ jump back to caller                  
