*-----------------------------------------------------------
* Title      : EA 
* Written by : GKITZ
* Date       : lol
* Description:
*-----------------------------------------------------------
    
* -- Equates -- 

EAbuffer EQU   $00070000    
Exit     EQU   $2700
TestLoc   EQU  $6001 
  
START:   ORG    $1000           
   bsr   Initialize_EA_Test_Pointer
   bsr   NEG
   jsr   Print_Comma
   
   jsr   Print_EA_String
   jsr   EXIT_TEST
*-----------------------
EXIT_TEST
   STOP   #Exit
*-----------------------
Initialize_EA
   lea   EAbuffer,A4 
   rts
*------------------------ 
Initialize_EA_Test_Pointer
   lea   TestLoc,A6
   rts
*------------------------  
*  A4 points to the string 
Print_EA_String
                bsr   Initialize_EA
             P_LOOP:   move.l      A4,A1
                cmp.l       #$ffffffff,(A1)      if nothing there don't print     
                beq         EXIT_SR              exit
                move.l      #14,D0
                trap        #15                  print 
                adda.l      #$00000004,A4        increment a4
                bra         P_LOOP     loop
*------------------------
EXIT_SR

   RTS
*------------------------
Decode_SIZE   *  register D3 has size bits
*---   sizes are byte:00, word:01, long:10
    cmp.l   #$00000003,d3
    beq   PRINT_DOT_B
    cmp.l  #$00000001,d3
    beq   Print_DOT_W
    cmp.l   #$00000002,d3
    beq   Print_DOT_L
    bra   ERROR_SIZE
*------------------------
ERROR_SIZE
   rts 
*------------------------
*---- passes size back in d3
Grab_Size_Bits  *--- a6 points to where size bits
    
    *--- adda.l   #$00000002,a5    
    move.b    (a6),d3  
    *-----adda.l   #$00000001,a6 
    andi.b   #%11000000,d3  
    ror   #6,d3

   rts  
*------------------------
Grab_Mode_Bits *--- grabs size bits and stores in d3
   clr   d3
   move.b   (a6),d3
   andi.b   #%00111000,d3
   ror   #3,d3
   rts 
*------------------------
PRINT_DOT_B
   move.b   #'.',(a4)+       dot to print
   move.b   #'B',(a4)+       "B" to print 
   move.b   #$09,(a4)+       prints spaces 
   move.b   #$00,(a4)+
   rts
*------------------------
Print_DOT_W
   move.b   #'.',(a4)+      dot to print
   move.b   #'W',(a4)+      "W" to print   
   move.b   #$09,(a4)+      prints spaces   
   move.b   #$00,(a4)+
   rts
*------------------------
Print_DOT_L
   move.b   #'.',(a4)+      dot to print
   move.b   #'L',(a4)+      "W" to print 
   move.b   #$09,(a4)+      prints spaces
   move.b   #$00,(a4)+
   rts
*------------------------
Print_Comma
   move.b   #',',(a4)+
   move.b   #$00,(a4)+
   rts
*------------------------
Close_String
   move.b   #$00,(a4)
   rts
*------------------------
Decode_DRD  *-- A6 points to it
   clr      d3
   move.b   (a6),d3
   andi.b   #%00000111,d3  grabs the register
   addi.b   #$30,d3
   move.b   #'D',(a4)+
   move.b   d3,(a4)+
  
   rts

*------------------------
Mode_Jump_Table *-- d3 has mode 
    cmp.b   #$00,d3     *drd
    beq   Decode_DRD
    cmp.b   #$02,d3      *ari
    beq   Decode_ARI
    cmp.b   #%00000011,d3     *ari pi
    beq   Decode_ARI_PI
    cmp.b   #%00000100,d3     *ari pd
    beq   Decode_ARI_PD
    cmp.b   #%00000111,d3      *ari
    beq     Absolute_Router
    bra   Mode_Error 
*------------------------
Decode_ARI
    clr      d3
    move.b   (a6),d3
    andi.b   #%00000111,d3  grabs the register
    addi.b   #$30,d3
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   d3,(a4)+
    move.b   #')',(a4)+
    move.b   #$00,(a4)
  
   rts
*------------------------
Mode_Error

*------------------------
Decode_ARI_PI
*------------------------
Decode_ARI_PD
*------------------------
Decode_IMM
*------------------------
Decode_ABS_LONG
*------------------------
Absolute_Router
*------------------------
DECODE_ABS_WORD
*------------------------
NOP
   
*------------------------
NEG
   bsr   Initialize_EA
   bsr   Grab_Size_Bits
   bsr   Decode_SIZE
   bsr   Grab_Mode_Bits
   bsr   Mode_Jump_Table
   rts


*------------------------
MOVE
*------------------------
MOVEA
*------------------------
MOVEM
*------------------------
ADD
*------------------------
ADDA
*------------------------
SUB
*------------------------
MULS
*------------------------
DIVS
*------------------------
LEA
*------------------------
OR
*------------------------
ORI
*------------------------
EOR
*------------------------
LSR
*------------------------
LSL
*------------------------
ASR
*------------------------
ROL
*------------------------
ROR
*------------------------
BCLR
*------------------------
CMP
*------------------------
CMPI
*------------------------
BCS
*------------------------
BGE
*------------------------
BLT
*------------------------
BVC
*------------------------
JSR
*------------------------
RTS
*------------------------



    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
