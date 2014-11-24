*-----------------------------------------------------------------* Title      :  EA
* Written by :  Greg Kitzmiller
* Date       :  11/18/14
* Description:  EA
*-----------------------------------------------------------------
and_mask_ls_eight   EQU   $00FF    
testString  EQU  $AE45 

FFFcomp  EQU  $000000FF  
000comp  EQU  $00000000
saveAddress EQU  $00007000
    
    
    
START:  ORG    $1000         ; first instruction of program

   move.w  #testString,D1   ;put test string in data register 
   

    JSR   BRA   ;Jumps to the branch always subroutine
    
    
    
    
******************************************************************
* Subroutine: Branch always
* Description: EA for BRA command - prints the PC offset that imm-
* idiately follows the instruction whether 8,16, or 32.    
******************************************************************
BRA   andi.l  #and_mask_ls_eight,D1  ;grab the least significant 8-bits
      CMP.L   #000comp,D1   ;if they're all 0's then grab the 16-bit displacement 
      BEQ     SIXTEEN_DISPLACE
      CMP.L   #FFFcomp,D1   ;if they're all F's then grab the 32 displacement
      BEQ   THIRTY_TWO_DISPLACE   ;  and store the 32 bit displacement
      BRA   EIGHT_DISPLACE   ;otherwise, store the displacement address as hex 
      ;retun   
*******************************************************************     
      
NOP   * NOP subroutine 
      RTS   ; literally, no EA is done for NOP - cool 

*******************************************************************
THIRTY_TWO_DISPLACE          ;grabs the 32-bit displacement
   RTS   ;returns to the caller

*******************************************************************
SIXTEEN_DISPLACE
    LEA   saveAddress,A2   ;   saves info into memory 
    MOVE.L  sixteen,(A2)+    ;   moves the sixteen bit displacement message
    MOVE.L  D1,(A2)+   ;   loads the displacement into the next slot   
    RTS   ;returns to the caller
*******************************************************************
    
EIGHT_DISPLACE   
    
*******************************************************************
* Subroutine: NEG
* Descritpion: 
NEG

*******************************************************************

    SIMHALT             ; halt simulator

sixteen  DC.L   '16 bit displacement for PC: ',0   ;   string for 16-bit displacement   

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
