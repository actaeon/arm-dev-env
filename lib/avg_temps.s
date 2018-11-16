next:             LDRB  R8,  [R0], #0x01          @  Load R8 with first value in timeslice array, bumb array ptr                 
                  ADD   R7,   R7, R8              @  Add timeslice to accumulator
                  SUBS  R6,   #0x01               @  Decrement counter                 
                  BNE   next                      @  next iteration if not done                 
                  MOVS  R7,   R7, LSR #4          @  integer divide by 16 using LSL. MSB of shifted
                                                  @    off values ends up in carry flag. If this bit is a one, then the value
                                                  @    of the remainder is at least .5. if 0 then remainder is < .5
                  ADC   R7,   #0                  @  Add the carry flag in any case                 
                  STRB  R7,   [R1]                @  Store the result in R1                 
                  NOP                             @  For breakpoint using debugger                 
