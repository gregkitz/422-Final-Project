*-----------------------------------------------------------------
* Title      :  EA
* Written by :  Greg Kitzmiller
* Date       :  11/18/14
* Description:  EA
*-----------------------------------------------------------------
starting_address   EQU   $6000   ; 
and_mask_ls_eight   EQU   $00FF    ;
testString  EQU  $AE45   ;
FFFcomp  EQU  $000000FF  ; ending 
comp_zero  EQU  $00000000   ;
saveAddress EQU  $00007000   ;
    
    
    
START:  ORG    $1000         ; first instruction of program

   move.w  #testString,D1   ;put test string in data register 
   

    JSR   BRA   ;   Jumps to the branch always subroutine
    move   (SP)+,D0   ;
    move   (SP)+,D1   ; 
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
BRA   lea   starting_address,A1   ;point to where we're reading 
      move.w  (A1)+,D1   ; move the word into d1
      andi.l  #and_mask_ls_eight,D1  ;grab the least significant 8-bits
      cmp.l   #comp_zero,D1   ;if they're all 0's then grab the 16-bit displacement 

      beq     SIXTEEN_DISPLACE
      cmp.l   #FFFcomp,D1   ;if they're all F's then grab the 32 displacement
      beq   THIRTY_TWO_DISPLACE   ;  and store the 32 bit displacement
      bra   EIGHT_DISPLACE   ;otherwise, store the displacement address as hex 
      ;retun   
*******************************************************************     
* 
NOP   * NOP subroutine 
      RTS   ; literally, no EA is done for NOP - cool 

*******************************************************************
THIRTY_TWO_DISPLACE          ;grabs the 32-bit displacement
   RTS   ;returns to the caller

*******************************************************************
    offset   4+4
returnString   ds.l   1
message        dc.l   'offset:',$d
      org   *   end of offset



SIXTEEN_DISPLACE
    link   A0,#0    ;   create stack frame
    move.w   (A1)+,D1   ;   saves offset 
    move.l   D1,(returnString,A0)   ;   save 16bit offset into string parameter
    move.l   (SP)+,D0  restore D0     
    unlk   A0
    rts   ;returns to the caller
*******************************************************************
    
EIGHT_DISPLACE   
    
*******************************************************************
* Subroutine: NEG
* Descritpion: 
NEG

*******************************************************************


   END   START   ; 

   SIMHALT   ;   end simulation 

sixteen  DC.L   '16 bit displacement for PC: ',0   ;   string for 16-bit displacement   

 




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
