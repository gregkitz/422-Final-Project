*-----------------------------------------------------------
* Title      :  Week one EA
* Written by :  Greg Kitzmiller
* Date       :  11/18/14
* Description:  Subroutines for the week one procudures
*-----------------------------------------------------------
and_mask   EQU   $00FF    
testString  EQU  $AE45 
FFFcomp  EQU  $000000FF   
saveAddress EQU  $00007000
    
    
    
START:  ORG    $1000         ; first instruction of program

   move.w  #testString,D1   ;put test string in data register 
   

    JSR   BRA   ;Jumps to the branch always subroutine
    
    
    
    
    
BRA   andi.l  #and_mask,D1  ;grab the least significant 8-bits
      CMP.L   #FFFcomp,D1   ;if they're all F's then grab the 32 displacement
      BEQ   thirty_two_displace   ;  and store the 32 bit displacement
      BRA   sixteen_displace   ;otherwise, store the displacement address as hex 
      ;retun   

thirty_two_displace 
         ;grabs the 32-bit displacement
   RTS   ;returns to the caller

sixteen_displace
    LEA   saveAddress,A2   ;   saves info into memory 
    MOVE.L  sixteen,(A2)+    ;   moves the sixteen bit displacement message
    MOVE.L  D1,(A2)+   ;   loads the displacement into the next slot   
    RTS   ;returns to the caller

    SIMHALT             ; halt simulator

sixteen  DC.L   '16 bit displacement for PC: ',0   ;   string for 16-bit displacement   

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
