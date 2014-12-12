*-----------------------------------------------------------
* Title      :   Greg Tests
* Written by :   Greg Kitzmiller
* Date       :   Mon Nov 24
* Description:   Testing the EA stuff I do, using this as memory 
*-----------------------------------------------------------
test   EQU   $73330
START:  ORG    $6000               ; first instruction of program

* BRA - w/ displacements afterward

   NEG    D0
   move   d2,a3   ; branch test 
   

TOBRANCH   move.b   #3,D0  
           ; just does something and branches to end 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
