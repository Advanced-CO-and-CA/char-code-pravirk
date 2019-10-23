
@ BSS section
.bss
GREATER: .word 0;

.data
LENGTH: .word 3;
START1: .ascii "C";
        .ascii "A";
        .ascii "T";

START2: .ascii "B"
        .ascii "A"
        .ascii "T"
/*
START2: .ascii "C"
        .ascii "A"
        .ascii "T"*/
/*
START2: .ascii "C"
        .ascii "U"
        .ascii "T"*/

.text
.globl main

main:
LDR R0, =LENGTH
LDR R0, [R0]    @get length of string
LDR R1, =START1 @get start address of string STR1
LDR R2, =START2 @get start address of string STR2

ADD R0, R0, R1  @R0<- stores ( the end address of STR1 + 1 )
MOV R5, #0      @R5, stores the comparison result

loop: @loop over the string 
           @either we reach the end of the string or
           @first point of different characters are found
  CMP R1, R0 @loop till [R1] < [R0], i.e. till end of the string
  BGE end_loop

  @iterate over to next characters in both the strings
  LDRB R3, [R1], #1
  LDRB R4, [R2], #1

  CMP R3, R4
  BEQ loop      @[R3]  = [R4], iterate the loop
  MOVLT R5, #-1 @[R3] != [R4], break out of the loop
                @[R3] < [R4], [R5]<-0xFFFFFFFF
end_loop:

LDR R0, =GREATER @get address of GREATER
STR R5, [R0];    @Store value of R5 @PRESENT

END: NOP @END
.end