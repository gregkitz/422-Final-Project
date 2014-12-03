*-----------------------------------------------------------------
* Title      :  EA
* Written by :  Greg Kitzmiller
* Date       :  11/18/14
* Description:  EA
*-----------------------------------------------------------------
starting_address   EQU   $00006000   ; 
save_space   EQU   $7000   ; 
and_mask_ls_eight   EQU   $00FF    ;
testString  EQU  $AE45   ;
FFFcomp  EQU  $000000FF  ; ending 
comp_zero  EQU  $00000000   ;
saveAddress EQU  $00007000   ;



******************************************************************
* sizes to compare in bits 7 & 8  - CURRENTLY NEG
* currently used for NEG 
* use comp 0 *  00 byte
size_word_NEG   EQU   $00000040 *  01 word
size_long_NEG   EQU   $00000080 *  10 long 
******************************************************************


******************************************************************
*      BIT ISOLATORS
******************************************************************
i_three_four_five   EQU   $00000038       ;
grab_seven_and_eight  EQU   $00000090     ; 
******************************************************************

******************************************************************
*      ADDRESSING MODES in bits 3,4,&5
ad_direct   EQU  $00000000   ;
ad_in   EQU   $00000010   ; 
ad_pre  EQU  $00000020   ; 
ad_post EQU   $00000018   ; 
ad_abs   EQU  $00000038       ;
******************************************************************


    
    
START:  ORG    $1000         ; first instruction of program

    lea   starting_address,A1   ;   move starting address into A1
    move.l   A1,-(SP)   ;   pass address on stack    

    JSR   BRA   ;   Jumps to the branch always subroutine
    movea   (SP)+,A1   ;   grabs the pointer to the string 
    lea   (8,SP),SP    ;  cleans stack 
    
    move   #14,D0   ;   14, display string 
    trap   #15   ;   display the string in A1     
    
    stop    #$2700
    
******************************************************************
* Subroutine: BRANCH ALWAYS
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
    offset   4+4            
address   dc.l   1 
    org     *      
    
    

BRA   
      link     A0,#0     ; create stack frame 
      move.l   (address,A0),A1   ;  pop the address from the stack 
      move.w  (A1)+,D1   ; move the word into d1
      andi.l  #and_mask_ls_eight,D1  ;grab the least significant 8-bits
      cmp.l   #comp_zero,D1   ;if they're all 0's then grab the 16-bit displacement 

      beq     SIXTEEN_DISPLACE
      cmp.l   #FFFcomp,D1   ;if they're all F's then grab the 32 displacement
      beq   THIRTY_TWO_DISPLACE   ;  and store the 32 bit displacement
      bra   EIGHT_DISPLACE   ;otherwise, store the displacement address as hex 
      

      unlk   A0 
      rts    ;   retun to OP-code   
******************************************************************
* Subroutine: NO OPERATION 
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
NOP   * NOP subroutine 
      RTS   ; literally, no EA is done for NOP - cool 



    
*******************************************************************
* Subroutine: NEG
* Descritpion: Subtracts destination operand from 0 and stores the
* result in destination location. Size is byte,word,long. 
* EA modes: DN, (AN) -/+, (xxx).l (xxx).w
*******************************************************************
NEG
     
     movea.b   (sp)+,a2  ; pop address pointer off stack
     move.b    (sp)+,d3   ; pop error flag off stack 
     clr       d3          ; clear D3
     clr       d2         ; clear d2
     move.b   (a2),d2    ; copy code to d2
     move.b   d2,d4      ;   make a copy to work with for size
     andi.l   #grab_seven_and_eight,d4   ;   isolate the necessary bits  
     cmp.l    #comp_zero,d4   ; compare D4 with with byte, and branch 
     beq      NEGBYTE
     cmp.l    #size_word_NEG,D4   ; compare D4 with word, and branch
     beq      NEGWORD
     cmp.l    #size_long_NEG ; compare D4 with long, and branch
     beq      NEGLONG      ; 
     bra      NEGERROR    ; if still here BRA to error in size 
     
     ; push error flag onto stack
     ; push (updated address pointer onto stack)
     
     rts     ;   return to subroutine
     
     
NEGBYTE
     lea   byte_message,A1   ;   loads 'offest' into A1
     move.b   #14,D0   ; print string with no newline 
     trap   #15   ;   trap call 
     
     clr   d4   * clear d4
     move.b  d2,d4   * copy data again to d4
     andi.l   #i_three_four_five,d4   * isolate mode bits
     cmp.l   #ad_direct,d4    * compare direct
     beq   NEGDIRECT   * beq
     cmp.l   #ad_in,d4   * compare indirect
      beq   NEGDINDIRECT   * beq
     cmp.l   #ad_pre,d4    * compare pre
      beq   NEGINDIRECTPRE   * beq
     cmp.l   #ad_post,d4   * compare post 
      beq   NEGINDIRECTPOST   * beq
     cmp.l   #ad_abs,d4    * compare absolute
      beq   NEGABSOLUTE   * beq
     bra   NEGERRORREGISTER   * bra to error register


     rts     ;   return to subroutine 
    

NEGWORD
     lea   word_message,A1   ;   loads 'offest' into A1
     move.b   #14,D0   ; print string with no newline 
     trap   #15   ;   trap call 

      
     rts     ;   return to subroutine 
NEGLONG
     lea   long_message,A1   ;   loads 'offest' into A1
     move.b   #14,D0   ; print string with no newline 
     trap   #15   ;   trap call 

  
     
     rts     ;   return to subroutine 

NEGDIRECT

NEGINDIRECT

NEGINDIRECTPRE

NEGINDIRECTPOST


NEGABSOLUTE

NEGERROR    *  not as deragatory as it sounds 
     ; push error flag onto stack
     ; push (updated address pointer onto stack)
     
     rts     ;   return to subroutine 
     
     
NEGERRORREGISTER

******************************************************************
* Subroutine: MOVE
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
MOVE

******************************************************************
* Subroutine: MOVE ADDRESS
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
MOVEA


******************************************************************
* Subroutine: MOVE MULTIPLE REGISTERS
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
MOVEM


******************************************************************
* Subroutine: ADD
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ADD


******************************************************************
* Subroutine: ADD ADDRESS
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ADDA


******************************************************************
* Subroutine: SUBTRACT
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
SUB


******************************************************************
* Subroutine: SUBTRACT QUICK
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
SUBQ


******************************************************************
* Subroutine: SIGNED MULTIPLY 
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
MULS


******************************************************************
* Subroutine: SIGNED DIVISION
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
DIVS


******************************************************************
* Subroutine: LOAD EFFECTIVE ADDRESS
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
LEA


******************************************************************
* Subroutine: INCLUSIVE-OR LOGICAL (4-150)
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
OR 


******************************************************************
* Subroutine: OR IMMEDIATE
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ORI 


******************************************************************
* Subroutine: NEGATE
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
NEG


******************************************************************
* Subroutine: EXCLUSIVE OR
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
EOR

******************************************************************
* Subroutine: LOGICAL SHIFT RIGHT
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
LSR


******************************************************************
* Subroutine: LOGICAL SHIFT LEFT
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
LSL


******************************************************************
* Subroutine: ARITHMETIC SHIFT RIGHT
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ASR


******************************************************************
* Subroutine: ARITHMETIC SHIFT LEFT
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ASL 


******************************************************************
* Subroutine: ROTATE LEFT
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ROL


******************************************************************
* Subroutine: ROR
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
ROR

******************************************************************
* Subroutine: TEST A BIT AND CLEAR (4-30)B
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
BCLR

******************************************************************
* Subroutine: COMPARE
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
CMP

******************************************************************
* Subroutine: COMPARE IMMEDIATE
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
CMPI

******************************************************************
* Subroutine: BRANCH CARRY SET (129)
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
BCS

******************************************************************
* Subroutine: BRANCH GREATER THAN OR EQUAL 
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
BGE


******************************************************************
* Subroutine: BACON LETTUCE TOMATO (LESS/EQUAL)
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
BLT 


******************************************************************
* Subroutine: BRANCH OVERFLOW CLEAR
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
BVC


******************************************************************
* Subroutine: JUMP TO SUBROUTINE 
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
JSR


******************************************************************
* Subroutine:RETURN TO SUBROUTINE 
* By: GKITZ
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
RTS

******************************************************************
*                   HELPER ROUTINES 
******************************************************************

*******************************************************************
THIRTY_TWO_DISPLACE          ;grabs the 32-bit displacement
   RTS   ;returns to the caller

*******************************************************************
SIXTEEN_DISPLACE
    movea.l  A1,A2   ;   save a1
    lea   sixteen_offset,A1   ;   loads 'offest' into A1
    move.b   #14,D0   ; print string with no newline 
    trap   #15   ;   trap call 
    movea.l   A2,A1   ; move a2 back to a1
    clr    D1   ;   clears register for printing offset 
    move.w   (A1)+,D1   ;   saves offset and increments
    move.b   #3,D0   ;   moves whatever is in D1.L
    trap     #15   ;
    move.l  A1,-(SP)   ;  saves the address on the stack 
    unlk   A0   ;   unlink A0 
    rts   ; return to subroutine 
*******************************************************************
    
EIGHT_DISPLACE   



*******************************************************************





   SIMHALT   ; 
   
sixteen_offset   dc.l   'displacement (in hex):  ',0   ; message to write out with displacement 

   END   START   ; 

   SIMHALT   ;   end simulation 

sixteen  DC.L   '16 bit displacement for PC: ',0   ;   string for 16-bit displacement   
byte_message   dc.b  '.b',0    ; 
word_message   dc.b  '.w',0    ;
long_message   dc.b  '.l',0    ; 

*******************************************************************
*  addressing print messages
*******************************************************************
*  single-operand register direct 
*******************************************************************
am_d0   dc.b   'D0',0    ;
am_d1   dc.b   'D1',0    ;
am_d2   dc.b   'D2',0    ;
am_d3   dc.b   'D3',0    ;
am_d4   dc.b   'D4',0    ;
am_d5   dc.b   'D5',0    ;
am_d6   dc.b   'D6',0    ;
am_d7   dc.b   'D7',0    ;
am_d8   dc.b   'D8',0    ;
am_a0   dc.b   'A0',0    ; 
am_a1   dc.b   'A1',0    ;
am_a2   dc.b   'A2',0    ;
am_a3   dc.b   'A3',0    ;
am_a4   dc.b   'A4',0    ;
am_a5   dc.b   'A5',0    ;
am_a6   dc.b   'A6',0    ;

*******************************************************************
*  single-operand  indirect 
*******************************************************************
am_a0_i   dc.b   '(A0)',0    ; 
am_a1_i   dc.b   '(A1)',0    ;
am_a2_i   dc.b   '(A2)',0    ;
am_a3_i   dc.b   '(A3)',0    ;
am_a4_i   dc.b   '(A4)',0    ;
am_a5_i   dc.b   '(A5)',0    ;
am_a6_i   dc.b   '(A6)',0    ;
*******************************************************************
*  single-operand  indirect pre-decrement 
*******************************************************************
am_a0_id   dc.b   '-(A0)',0    ; 
am_a1_id   dc.b   '-(A1)',0    ;
am_a2_id   dc.b   '-(A2)',0    ;
am_a3_id   dc.b   '-(A3)',0    ;
am_a4_id   dc.b   '-(A4)',0    ;
am_a5_id   dc.b   '-(A5)',0    ;
am_a6_id   dc.b   '-(A6)',0    ;
*******************************************************************
*  single-operand  indirect post-increment
*******************************************************************
am_a0_ii   dc.b   '(A0)+',0    ; 
am_a1_ii   dc.b   '(A1)+',0    ;
am_a2_ii   dc.b   '(A2)+',0    ;
am_a3_ii   dc.b   '(A3)+',0    ;
am_a4_ii   dc.b   '(A4)+',0    ;
am_a5_ii   dc.b   '(A5)+',0    ;
am_a6_ii   dc.b   '(A6)+',0    ;














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
