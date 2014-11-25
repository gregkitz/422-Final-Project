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
* Subroutine: Branch always
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
*******************************************************************     
* 
NOP   * NOP subroutine 
      RTS   ; literally, no EA is done for NOP - cool 

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
* Subroutine: NEG
* Descritpion: 
NEG

*******************************************************************
   SIMHALT   ; 
   
sixteen_offset   dc.l   'displacement (in hex):  ',0   ; message to write out with displacement 

   END   START   ; 

   SIMHALT   ;   end simulation 

sixteen  DC.L   '16 bit displacement for PC: ',0   ;   string for 16-bit displacement   

 











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
