*-----------------------------------------------------------
* Title      : Week 1 OP Code
* Written by : Dallas Van Ess
* Date       : 11/18/2014
* Description: Code for Week 1 
*-----------------------------------------------------------

* Equates Section
CR          EQU         $0D             * Hex value for Carriage Return
LF          EQU         $0A             * Hex value for New Line Read
START       EQU         $400            * Address for ORG
start_addr  EQU         $00007000       * Starting address where the program is stored
test_bit1   EQU         $01442345       * A Value to be used for testing    
pattern     EQU         $3456           * Test pattern
holder      EQU         $3F0            * Location of lines to test
nop_str     EQU         $4E71           * Hex value for NOP
neg_str     EQU         $44             * Hex value for NEG
jsr_str     EQU         $13A            * Hex value for JSR
rts_str     EQU         $4E75           * Hex value for RTS
bcc_str     EQU         $6              * Hex value for BCC
bcs_str     EQU         $5              * Hex value for BCS
bge_str     EQU         $C              * Hex value for BGE
blt_str     EQU         $D              * Hex value for BLT
bvc_str     EQU         $8              * Hex value for BVC
bra_str     EQU         $60             * Hex value for BRA
EXIT        EQU         $2700           * Simulator Stop code

* Code Section
            ORG         START
            LEA         holder,A0       * Store pattern to find     
            MOVE.L     #test_bit1,(A0) * Store test bit         
            MOVE.L      (A0),D0        * Move the entire line into D0
            
            CMP         #nop_str,D0     * is it NOP?
            BEQ         NOP_RT          * If so, branch to NOP subroutine
            CMP         #neg_str,D0     * is it NEG?
            BEQ         NEG_RT          * If so, branch to NEG subroutine
            CMP         #jsr_str,D0     * is it JSR?
            BEQ         JSR_RT          * If so, branch to JSR subroutine
            CMP         #rts_str,D0     * is it RTS?
            BEQ         RTS_RT          * If so, branch to RTS subroutine
            CMP         #bcc_str,D0     * is it BCC?
            BEQ         BCC_RT          * If so, branch to BCC subroutine
            CMP         #bra_str,D0     * is it BRA?
            BEQ         BRA_RT          * If so, branch to BRA subroutine

            MOVE.L      D0,D2           * Save initial D0 for later use                                             

BYTES:      CMP.L       #0,D0           * Is the register complteley empty?
            BEQ         RESET           * Reset D0
            MOVE.W      D0,D3           * Move the Least significant byte into D3
            CMP         #nop_str,D3     * is it NOP?
            BEQ         NOP_RT          * If so, branch to NOP subroutine
            CMP         #neg_str,D3     * is it NEG?
            BEQ         NEG_RT          * If so, branch to NEG subroutine
            CMP         #jsr_str,D3     * is it JSR?
            BEQ         JSR_RT          * If so, branch to JSR subroutine
            CMP         #rts_str,D3     * is it RTS?
            BEQ         RTS_RT          * If so, branch to RTS subroutine
            CMP         #bcc_str,D3     * is it BCC?
            BEQ         BCC_RT          * If so, branch to BCC subroutine
            CMP         #bra_str,D3     * is it BRA?
            BEQ         BRA_RT          * If so, branch to BRA subroutine
            ANDI.B      #$F0,D3         * Clear very last digit
            ASR.W       #4,D3           * Shift remaining digits right 
            CMP         #nop_str,D3     * is it NOP?
            BEQ         NOP_RT          * If so, branch to NOP subroutine
            CMP         #neg_str,D3     * is it NEG?
            BEQ         NEG_RT          * If so, branch to NEG subroutine
            CMP         #jsr_str,D3     * is it JSR?
            BEQ         JSR_RT          * If so, branch to JSR subroutine
            CMP         #rts_str,D3     * is it RTS?
            BEQ         RTS_RT          * If so, branch to RTS subroutine
            CMP         #bcc_str,D3     * is it BCC?
            BEQ         BCC_RT          * If so, branch to BCC subroutine
            CMP         #bra_str,D3     * is it BRA?
            BEQ         BRA_RT          * If so, branch to BRA subroutine
            ANDI.B      #$F0,D0         * Clear very last digit
            ASR.L       #4,D0           * Shift remaining digits right
            BRA         BYTES           * restart  
            
BITS:       CMP.L       #0,D0           * Is the register completely empty?
            BEQ         N_FOUND         * Nothing was found
            MOVE.B      D0,D3           * Move the Least significant byte into D3        
            CMP         #nop_str,D3     * is it NOP?
            BEQ         NOP_RT          * If so, branch to NOP subroutine
            CMP         #neg_str,D3     * is it NEG?
            BEQ         NEG_RT          * If so, branch to NEG subroutine
            CMP         #jsr_str,D3     * is it JSR?
            BEQ         JSR_RT          * If so, branch to JSR subroutine
            CMP         #rts_str,D3     * is it RTS?
            BEQ         RTS_RT          * If so, branch to RTS subroutine
            CMP         #bcc_str,D3     * is it BCC?
            BEQ         BCC_RT          * If so, branch to BCC subroutine
            CMP         #bra_str,D3     * is it BRA?
            BEQ         BRA_RT          * If so, branch to BRA subroutine
            ANDI.B      #$F0,D0         * Clear very last digit
            ASR.L       #4,D0           * Shift remaining digits right 
            BRA         BITS            * restart  
            
FOUND:      LEA         found_it,A1
            MOVE.B      #14,D0
            TRAP        #15
            BRA         FINISH

            
NOP_RT:     LEA         nop_message,A1  * Print NOP
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BRA         FINISH
NEG_RT:     LEA         neg_message,A1  * Print NEG
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
            BRA         FINISH
JSR_RT:     LEA         jsr_message,A1  * Print JSR
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BRA         FINISH
RTS_RT:     LEA         rts_message,A1  * Print RTS
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BRA         FINISH
BCC_RT:     LEA         bcc_message,A1  * Print BCC
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
            BRA         FINISH
BRA_RT:     LEA         bra_message,A1  * Print BRA
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
            BRA         FINISH                        
           
N_FOUND:    LEA         not_found,A1
            MOVE.B      #14,D0
            TRAP        #15
            BRA         FINISH 
RESET       MOVE.L      D2,D0
            BRA         BITS           
            
            
FINISH:     LEA         finished,A1
            MOVE.B      #14,D0
            TRAP        #15                       
            STOP        #EXIT           * Halt Execution                                            
           
* Data Section
finished    DC.B        'Finished',CR,LF,0
found_it    DC.B        'Found it!',CR,LF,0
not_found   DC.B        'No Opcodes were found',CR,LF,0
nop_message DC.B        'NOP',CR,LF,0
neg_message DC.B        'NEG',CR,LF,0
jsr_message DC.B        'JSR',CR,LF,0
rts_message DC.B        'RTS',CR,LF,0
bcc_message DC.B        'BCC',CR,LF,0
bcs_message DC.B        'BCS',CR,LF,0
bge_message DC.B        'BGE',CR,LF,0
blt_message DC.B        'BLT',CR,LF,0
bvc_message DC.B        'BVC',CR,LF,0
bra_message DC.B        'BRA',CR,LF,0
data        DC.B        'DATA ',0    


            END         START





   







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
