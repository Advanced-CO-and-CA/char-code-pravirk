
@ BSS section
.bss
PRESENT: .word 0;

.data
STRING: .ascii "C";
        .ascii "S";
        .ascii "6";
        .ascii "6";
        .ascii "2";
        .ascii "0";
        .ascii "\0";

SUBSTR: .ascii "S";
        .ascii "S";
        .ascii "\0";
/*
SUBSTR: .ascii "6";
        .ascii "2";
        .ascii "0";
        .ascii "\0"; */
/*
SUBSTR: .ascii "6";
        .ascii "\0"; */
.text
.globl main

main:
LDR R0, =STRING @get start address of STRING
LDR R1, =SUBSTR @get start address of SUBSTR

MOV R4, #0 @use as counter to iterate over STRING
MOV R5, #0 @use as counter to iterate over SUBSTR

LDRB R2, [R0] @get first char from STRING
LDRB R3, [R1] @get first char from SUBSTR

loop: @loop till either of STRING or SUBSTR ends
  CMP R2, #0
  BEQ end_loop
  CMP R3, #0
  BEQ end_loop

  CMP R2, R3
  BNE slide_window_left

  @chars match, move to the next char
  ADD R4, #1
  ADD R5, #1
  LDRB R2, [R0, R4]
  LDRB R3, [R1, R5]
  B loop

  @chars do not match, [R4]<- ( [R4] - ( [R5] - 1 ) ), [R5]<- 0
  slide_window_left:
  SUB R4, R5
  ADD R4, #1
  MOV R5, #0
  @load next char
  LDRB R3, [R1, R5]
  LDRB R2, [R0, R4]
  B loop
end_loop:

CMP R5, #0 @[R5] is 0, SUBSTR not present in STRING
BEQ update_result

@[R5] is non zero, SUBSTR is present in STRING @( [R4] - ( [R5] - 1 ) )
SUB R5, R4, R5 @[R5] <- ( [R4] - [R5] )
ADD R5, #1     @[R5] <- ( [R5] + 1 )

update_result:
LDR R0, =PRESENT @get address of PRESENT
STR R5, [R0]; @Store value of R5 @PRESENT

