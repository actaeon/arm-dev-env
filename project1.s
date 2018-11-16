.text

.global AverageTemps
.global MinMax
.global MinMaxWrapper
.equ    TEMP_COUNT, 0x10

AverageTemps:     STMFD R13!, {R4-R8, R14}

                  LDR   R6,   =TEMP_COUNT
                  MOV   R7,   #0

.include "./lib/avg_temps.s"

                  LDMFD R13!, {R4-R8, R14}
                  MOV   PC,   R14                  


MinMaxWrapper:    STMFD R13!, {R4-R6, R14}
                  MOV   R4,   r1
                  MOV   R5,   r2
                  MOV   R1, #0x10

                  BL MinMax

                  STRB  R0,   [R4]
                  STRB  R1,   [R5]

                  LDMFD R13!, {R4-R6, R14}
                  MOV   PC,   R14                  

.include "./lib/min_max.s"

.end
