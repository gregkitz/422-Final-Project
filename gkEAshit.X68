*-----------------------------------------------------------
* Title      : EA 
* Written by : GKITZ
* Date       : lol
* Description:
*-----------------------------------------------------------
    
* -- Equates -- 

EAbuffer EQU   $00070000    
Exit     EQU   $2700
TestLoc   EQU  $6000 
  
START:   ORG    $1000           
   bsr   Initialize_EA_Test_Pointer
   bsr   NEG
   bsr   MOVE
   
   bsr   Print_EA_String
   bsr   EXIT_TEST
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
    cmp.l   #$00000000,d3
    beq   PRINT_DOT_B
    cmp.l  #$00000001,d3
    beq   Print_DOT_W
    cmp.l   #$00000002,d3
    beq   Print_DOT_L
    bra   ERROR_SIZE
*------------------------
Decode_Size_Two   *---used in move
    cmp.l   #$00000001,d3
    beq   PRINT_DOT_B
    cmp.l  #$00000003,d3
    beq   Print_DOT_W
    cmp.l   #$00000002,d3
    beq   Print_DOT_L
    bra   ERROR_SIZE

*------------------------
ERROR_SIZE
   rts 
*------------------------
*---- passes size back in d3
Grab_Size_Bits_Seven_Eight  *--- a6 points to where size bits
    
    *--- adda.l   #$00000002,a5    
    move.w    (a6),d3  
    *-----adda.l   #$00000001,a6 
    andi.w   #$00C0,d3  
    ror   #6,d3
   rts  
*------------------------
Grab_Size_Bits_Two
   move.b   (a6),d3
   andi.b   #$30,d3
   ror   #4,d3
   
   rts

*------------------------
Grab_Mode_Bits *--- grabs mode bits and stores in d3
   clr   d3
   move.w   (a6),d3
   andi.w   #%0000000000111000,d3
   ror   #3,d3
   rts 
*------------------------
Grab_Dest_Mode_Bits
   clr   d3
   move.w   (a6),d3
   andi.w   #%0000000111000000,d3
   ror   #6,d3
   rts
*------------------------
Grab_Source_Mode_Bits
   clr   d3
   move.w   (a6),d3
   andi.w   #%00000000000111000,d3
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
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   rts
*------------------------
Grab_Source_Reg  *--- grabs and puts into d4
   clr   d4
   move.w  (a6),d4 
   andi.w   #%0000000000000111,d4
   rts

*------------------------
Grab_Dest_Reg   *--- grabs and puts into d4
   clr   d4
   move.w  (a6),d4 
   andi.w   #%0000111000000000,d4
   ror   #8,d4
   ror   #1,d4
   rts
*------------------------
Close_String
   move.b   #$00,(a4)
   rts
*------------------------
Decode_DRD  *-- d4 has the reg
   addi.b   #$30,d4
   move.b   #'D',(a4)+
   move.b   d4,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   rts

*------------------------
Mode_Jump_Table *-- d3 has mode 
    cmp.b   #$00,d3     *drd
    beq   Decode_DRD
    cmp.b   #$02,d3      *ari
    beq   Decode_ARI
    cmp.b   #$03,d3     *ari pi
    beq   Decode_ARI_PI
    cmp.b   #$04,d3     *ari pd
    beq   Decode_ARI_PD
    cmp.b   #$07,d3      *ari
    beq     Absolute_Router
    bra   Mode_Error 
*------------------------
Decode_ARI
    addi.b   #$30,d4
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   d4,(a4)+
    move.b   #')',(a4)+
    move.b   #$00,(a4)
  
   rts
*------------------------
Mode_Error

*------------------------
Decode_ARI_PI
    
    addi.b   #$30,d4
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   d4,(a4)+
    move.b   #$00,(a4)+
    move.b   #')',(a4)+
    move.b   #'+',(a4)+
    move.b   #$00,(a4)+
    move.b   #$00,(a4)+
   rts


*------------------------
Decode_ARI_PD
    
    addi.b   #$30,d4
    move.b   #'-',(a4)+
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   #$00,(a4)+
    move.b   d4,(a4)+
    move.b   #')',(a4)+
    move.b   #$00,(a4)+
    move.b   #$00,(a4)+
    rts
*------------------------
Decode_IMM
*------------------------
Decode_ABS_LONG    *---code reuse, will make separate procudure if time 
   clr   d1
   clr   d2
   clr   d3
   clr   d4
   clr   d5
   adda.w   #$1,a6
   move.w   (a6)+,d3
   move.w   d3,d4
   move.w   d3,d2
   move.w   d3,d5
   move.w   d3,d1
   andi.l   #$0000F000,d2
   ror      #8,d2
   ror      #4,d2
   
   addi.b   #$30,d2
   andi.l   #$00000F00,d3
   ror      #8,d3
   addi.b   #$30,d3
   andi.l   #$000000F0,d4
   ror      #4,d4
   addi.b   #$30,d4
   andi.l   #$0000000F,d5
   addi.b   #$30,d5
   move.l   #'ab.l',(a4)+
   move.l   #$00000000,(a4)+
   move.b   d2,(a4)+
   move.b   d3,(a4)+
   move.w   #$0000,(a4)+
   move.b   d4,(a4)+
   move.b   d5,(a4)+
   move.w   #$0000,(a4)+
   
   
   
   clr   d1
   clr   d2
   clr   d3
   clr   d4
   clr   d5
   move.w   (a6)+,d3
   move.w   d3,d4
   move.w   d3,d2
   move.w   d3,d5
   move.w   d3,d1
   andi.l   #$0000F000,d2
   ror      #8,d2
   ror      #4,d2
   
   addi.b   #$30,d2
   andi.l   #$00000F00,d3
   ror      #8,d3
   addi.b   #$30,d3
   andi.l   #$000000F0,d4
   ror      #4,d4
   addi.b   #$30,d4
   andi.l   #$0000000F,d5
   addi.b   #$30,d5
   move.b   d2,(a4)+
   move.b   d3,(a4)+
   move.w   #$0000,(a4)+
   move.b   d4,(a4)+
   move.b   d5,(a4)+
   move.w   #$0000,(a4)+
   rts
   

*------------------------
Absolute_Router  *-- branches to word or long subprocedures based on register info 
    clr      d3
    move.b   (a6)+,d3
    andi.b   #%00000111,d3  grabs the register
    cmp.b   #$00,d3
    beq   DECODE_ABS_WORD
    cmp.b   #$01,d3
    beq   DECODE_ABS_LONG
    bra   Absolute_Error
*------------------------
DECODE_ABS_WORD
   clr   d1
   clr   d2
   clr   d3
   clr   d4
   clr   d5
   adda.w   #1,a6
   move.w   (a6)+,d3
   move.w   d3,d4
   move.w   d3,d2
   move.w   d3,d5
   move.w   d3,d1
   andi.l   #$0000F000,d2
   ror      #8,d2
   ror      #4,d2
   
   addi.b   #$30,d2
   andi.l   #$00000F00,d3
   ror      #8,d3
   addi.b   #$30,d3
   andi.l   #$000000F0,d4
   ror      #4,d4
   addi.b   #$30,d4
   andi.l   #$0000000F,d5
   addi.b   #$30,d5
   move.l   #'ab.w',(a4)+
   move.l   #$00000000,(a4)+
   move.b   d2,(a4)+
   move.b   d3,(a4)+
   move.w   #$0000,(a4)+
   move.b   d4,(a4)+
   move.b   d5,(a4)+
   move.w   #$0000,(a4)+
   rts
*------------------------
Absolute_Error

*------------------------
NOP
   
*------------------------
NEG
   bsr   Initialize_EA
   bsr   Grab_Size_Bits_Seven_Eight
   bsr   Decode_SIZE
   bsr   Grab_Mode_Bits
   bsr   Grab_Dest_reg
   bsr   Mode_Jump_Table
   rts


*------------------------
MOVE
   bsr   Initialize_EA
   bsr   Grab_Size_Bits_Two
   bsr   Decode_SIZE_Two
   bsr   Grab_Source_Mode_Bits
   bsr   Grab_Source_Reg
   bsr   Mode_Jump_Table
   bsr   Print_Comma
   bsr   Grab_Dest_Mode_Bits
   bsr   Grab_Dest_reg 
   bsr   Mode_Jump_Table
   rts
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
